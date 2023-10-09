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
}
