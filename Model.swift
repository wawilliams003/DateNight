//
//  Model.swift
//  DateNight
//
//  Created by Wayne Williams on 12/17/22.
//

import Foundation



struct Result: Decodable {
    let categories: [Categories]
    
}


struct Categories: Decodable {
    let title: String
    let image: String
    let color: String
    let items : [String]
}


class FetchData {
    
    static func parseJSON (completion: @escaping ([Categories])-> () ) {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {return}
        let url = URL(fileURLWithPath: path)
        var categories = [Categories]()
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
