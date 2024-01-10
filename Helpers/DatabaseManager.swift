//
//  DatabaseManager.swift
//  DateNight
//
//  Created by Wayne Williams on 9/24/23.
//

import Foundation
import FirebaseDatabase
import UIKit


final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
   static let notificationRef = Database.database().reference().child("notifications")
    
    /// Inserts new user to database
    public func insertUser(with user: KonnectUser, completion: @escaping (Bool) -> ()){
        let values: [String : Any] = ["name": user.name,
                               "email": user.email,
                      "isActive": user.isActive]
        database.child(user.safeEmail).setValue(values) { error, ref in
            guard error == nil else {
                completion(false)
                return
            }
            UserDefaults.standard.set(user.email, forKey: "email")
            self.database.child("users").observeSingleEvent(of: .value) { snapahot in
                if var usersCollection = snapahot.value as? [[String: String]] {
                    // append to user dictionary
                    let newElement = [
                        "name":user.name,
                         "email": user.safeEmail
                        ]
                    
                    usersCollection.append(newElement)
                    self.database.child("users").setValue(usersCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                    }
                    
                    
                } else {
                    // create user array
                    let newCollection: [[String: String]] = [
                        ["name":user.name,
                         "email": user.safeEmail]
                    ]
                    
                    self.database.child("users").setValue(newCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                           
                        }
                        completion(true)
                    }
                    
                }
            }
            
            
            completion(true)
            
        }
    }
    
    public func isUserExists(with email: String, completion: @escaping ((Bool) -> ())) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    static func safeEmail(email: String) -> String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
        
    }
    
    
    public func getAllUsers(completion: @escaping (Swift.Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseErrors.failedToFetch))
                return
            }
            completion(.success(value))
        })
        
    }
    
    
    public enum DatabaseErrors: Error {
        case failedToFetch
    }
    
    
}


struct KonnectUser {
    let name: String
    let email: String
    let isActive: Bool
    
    var safeEmail: String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    
    var profilePictureFileName: String {
         "\(safeEmail)_profile_picture.png"
    }
    
    
}

extension DatabaseManager {
    
    
     var dateFormatter: DateFormatter  {
        let formmater = DateFormatter()
        formmater.dateStyle = .medium
        formmater.timeStyle = .long
        formmater.locale = .current
        
        return formmater
    }
    
    
    public func createConnection(with withOtherUserEmail: String, withCard: UsersCard, name: String, complection: @escaping (Bool) -> ()) {
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
        let currentName = UserDefaults.standard.value(forKey: "name") as? String else {
            return
            
        }
        let safeEmail = DatabaseManager.safeEmail(email: currentEmail)
        
        let ref = database.child("\(safeEmail)")
        
        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
            complection(false)
                print("User Not Found")
                return
            }
            
            let cardDate = withCard.sentDate
            let dateString = self?.dateFormatter.string(from: cardDate)
            
            let connectionID =  "connection_\(withCard.cardId)"
            
            let newConnectionData : [String: Any] = [
                "id":connectionID,
                "other_user_email": withOtherUserEmail,
                "other_user_name": name,
                "sender": 0,
                "latest_card": [
                    "date": dateString,
                    "text": "Creator"
                    
                ]
            
            ]
            
            let recipient_newConnectionData : [String: Any] = [
                "id":connectionID,
                "other_user_email": safeEmail,
                "other_user_name": currentName,
                "sender": 1,
                "latest_card": [
                    "date": dateString,
                    "text": "Recipient"
                    
                ]
            
            ]
            
            // Update Recipient Connection Entry
            self?.database.child("\(withOtherUserEmail)/connections").observeSingleEvent(of: .value) { [weak self] snapshot in
                if var connections = snapshot.value as? [[String:Any]]  {
                    // append
                    
                    connections.append(recipient_newConnectionData)
                    self?.database.child("\(withOtherUserEmail)/connections").setValue(connections)
                    
                } else {
                    
                    // Create New Recipient connection
                    self?.database.child("\(withOtherUserEmail)/connections").setValue([recipient_newConnectionData])
                    
                    
                }
            }

            if var connections = userNode["connections"] as? [[String: Any]] {
                // connection array for current user
                // you should append
                connections.append(newConnectionData)
                userNode["connections"] = [ newConnectionData ]
                ref.setValue(userNode) { [weak self] error, _ in
                    guard error == nil else {
                        complection(false)
                        return
                    }
                    
                    self?.finnishCreatigConnecton(name: name, connectionID: connectionID, firstCard: withCard, completion: complection)

                }
                
                
                
            } else {
               // connection array does not exist
                userNode["connections"] = [newConnectionData ]
                
                ref.setValue(userNode) { [weak self] error, _ in
                    guard error == nil else {
                        complection(false)
                        return
                    }
                    self?.finnishCreatigConnecton(name: name, connectionID: connectionID, firstCard: withCard, completion: complection)
                   
                }
                
                
                
            }
            
        }
    }
    
    
    private func finnishCreatigConnecton(name: String, connectionID: String, firstCard: UsersCard, completion: @escaping(Bool) -> ()) {
        
        let cardDate = firstCard.sentDate
        let dateString = self.dateFormatter.string(from: cardDate)
        
        guard let myEmail =  UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return }

        let currentUserEmail = DatabaseManager.safeEmail(email: myEmail)
        
        let card: [String: Any] = [
            "id":firstCard.cardId,
            "content": firstCard.text,
            "date": dateString,
            "sender_email":currentUserEmail,
            "is_active": false,
            "name": name
        ]
        
        let value: [String: Any] = [
            "usersCard": [
              card
            ]
        ]
        
        
        database.child("\(connectionID)").setValue(value) { error, _ in
            guard error == nil else {
                completion(false)
                return
                
            }
            completion(true)
        }
        
        
    }
    
    
    public func getAllConnections(for email: String, completion: @escaping (Swift.Result<[Connection], Error>) -> Void) {
        
        //let listener =  database.child("\(email)/connections")
        
        database.child("\(email)/connections").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseErrors.failedToFetch))
                return }
            
            let connections: [Connection] = value.compactMap { dictionary in
                guard let connectionId = dictionary["id"] as? String,
                        let name = dictionary["other_user_name"] as? String,
                      let otherUserEmail = dictionary["other_user_email"] as? String,
                      let sender = dictionary["sender"] as? Int,
                      let latestCard = dictionary["latest_card"] as? [String: Any],
                      let date = latestCard["date"] as? String,
                      let text = latestCard["text"] as? String else {
                    return nil
                    
                }
                
                let latestCardObject = LatestCard(date: date, text: text)

                return Connection(id: connectionId, name: name
                                  , otherUserEmail: otherUserEmail , latestCard: latestCardObject, sender: sender)
                
            }
            
            completion(.success(connections))

        })

       
        
    }
    
    public func sendCard(to connection: String, card: UsersCard, name: String, completion: @escaping (Bool) ->()) {
        self.database.child("\(connection)/usersCard").observeSingleEvent(of: .value) { snapshot in
            guard var currentCards = snapshot.value as? [[String: Any]] else {
               completion(false)
                return
            }
            
            let cardDate = card.sentDate
            let dateString = self.dateFormatter.string(from: cardDate)
            
            guard let myEmail =  UserDefaults.standard.value(forKey: "email") as? String else {
                completion(false)
                return }

            let currentUserEmail = DatabaseManager.safeEmail(email: myEmail)
            
            let newCard: [String: Any] = [
                "id":card.cardId,
                "content": card.text,
                "date": dateString,
                "sender_email":currentUserEmail,
                "is_active": false,
                "name": name
            ]
            
            currentCards.append(newCard)
            
            self.database.child("\(connection)/usersCard").setValue(currentCards) { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
            
//            let value: [String: Any] = [
//                "usersCard": [
//                  card
//                ]
//            ]
            
            
            
        }

        
    }
    
    public func getLastCard(with id: String, completion: @escaping (Swift.Result<UsersCard, Error>) -> ()) {
        database.child("\(id)/usersCard").observe(.childAdded) { [weak self] snapshot, error in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseErrors.failedToFetch))
                return
            }
            
            let userCard: [UsersCard] = value.compactMap { dictionary in
                guard let name = dictionary["name"] as? String,
                      let isActive = dictionary["is_active"] as? Bool,
                      let cardId = dictionary["id"] as? String,
                      let content = dictionary["content"] as? String,
                      let dateString = dictionary["date"] as? String,
                      let  senderEmail = dictionary["sender_email"] as? String,
                      let date = self?.dateFormatter.date(from: dateString)   else {
                    return nil
                }
                
                let sender = Sender(photoURL: "",
                                    senderEmail: senderEmail,
                                    displayName: name)
                
                
                return UsersCard(sender: sender, cardId: cardId, sentDate: date, text: content,  isActive: isActive)
                
            }
            
            completion(.success(userCard.last!))
        }
    }
    
    
    /// Get all Cards fior given connection
    public func getAllCardsForCOnncetion( with id: String, completion: @escaping (Swift.Result<[UsersCard], Error>) -> ()) {
        database.child("\(id)/usersCard").observe(.value) { [weak self] snapshot, error in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseErrors.failedToFetch))
                return
            }
            
            let userCard: [UsersCard] = value.compactMap { dictionary in
                guard let name = dictionary["name"] as? String,
                      let isActive = dictionary["is_active"] as? Bool,
                      let cardId = dictionary["id"] as? String,
                      let content = dictionary["content"] as? String,
                      let dateString = dictionary["date"] as? String,
                      let  senderEmail = dictionary["sender_email"] as? String,
                      let date = self?.dateFormatter.date(from: dateString)   else {
                    return nil
                }
                
                let sender = Sender(photoURL: "",
                                    senderEmail: senderEmail,
                                    displayName: name)
                
                
               return UsersCard(sender: sender, cardId: cardId, sentDate: date, text: content,  isActive: isActive)
            }
            //print("USER CARD \(userCard)")
            completion(.success(userCard))
        }
    }
    
    public func getDataFor(path: String, completion: @escaping (Swift.Result<Any, Error>) ->()) {
        self.database.child("\(path)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseErrors.failedToFetch))
                return
            }
            
            completion(.success(value))
            
        }  
    }
    
     
    
}
    
    

