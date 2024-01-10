//
//  Model.swift
//  DateNight
//
//  Created by Wayne Williams on 12/17/22.
//

import Foundation



struct Result: Decodable {
    let categories: [Category]
    
}


struct Category: Codable {
    let title: String
    let image: String
    let color: String
    var items : [String]
    var frame: String? = nil
}


class FetchData {
    
    static func parseJSON (completion: @escaping ([Category])-> () ) {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {return}
        let url = URL(fileURLWithPath: path)
        var categories = [Category]()
        do {
            let jsonData = try Data(contentsOf: url)
            let results = try JSONDecoder().decode(Result.self, from: jsonData)
            categories = results.categories
            completion(categories)
            
        } catch {
            print("JSON ERROR: \(error.localizedDescription)")
        }
        
        
        
    }
  
}

struct Sender {
    var photoURL: String
    var senderEmail: String
    var displayName: String
}


struct UsersCard {
    var sender: Sender
    var cardId: String
    var sentDate: Date
    var text: String
    var isActive: Bool = false
}


struct UsersCardSent {
    let content: String
    let date: Date
    let id: String
    let isActive: Bool
    let name: String
    let senderEmail: String
}


struct Connection {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestCard: LatestCard
    let sender: Int
    //let imageUrl = UserDefaults.standard.value(forKey: "")
}


struct LatestCard {
    let date: String
    let text: String
}

struct AppUSer {
    var name: String
    var email: String
    var imageUrl: URL
}


struct Notification {
    var id: String
    var didChecked = false
    var creationDate: Date
    var receiverEmail: String
    var senderEmail: String
    var senderName: String
    var type: Int
    /*
    init(dictionary: [String: AnyObject]) {

        if let id = dictionary["id"] as? String {
            self.id = id
        }
        //self.id = (result["checked"] as? String)! else {return}
        if let checked = dictionary["checked"] as? Int {
            if checked == 0 {
                self.didChecked = false
            } else {
                self.didChecked = true
            }
        }

        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
        
        if let receiverEmail = dictionary["receiverEmail"] as? String {
            self.receiverEmail = receiverEmail
        }
        
        if let senderEmail = dictionary["senderEmail"] as? String {
            self.senderEmail = senderEmail
        }
        
    }
*/
    
}
