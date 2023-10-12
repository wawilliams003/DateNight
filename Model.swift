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
    var senderId: String
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
