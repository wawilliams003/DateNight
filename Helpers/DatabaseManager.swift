//
//  DatabaseManager.swift
//  DateNight
//
//  Created by Wayne Williams on 9/24/23.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
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

