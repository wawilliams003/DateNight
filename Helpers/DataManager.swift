//
//  DataManager.swift
//  DateNight
//
//  Created by Wayne Williams on 12/24/22.
//

import Foundation
import Disk
import UIKit

class DataManager {
    
    static let instance = DataManager()
    let folders = ["Health","Life","Goals","Love"]
    let favoriteString = "Favorites/"
    
    func saveCard(category: Category) {
        let folder =  favoriteString + category.title
        if Disk.exists(folder, in: .documents){
            do {
                var fetchedcategory =  try Disk.retrieve(folder, from: .documents, as: Category.self)
                var items = fetchedcategory.items
                items.append(category.items.first!)
                fetchedcategory.items.append(category.items.first!)
                try Disk.save(fetchedcategory, to: .documents, as: folder)
            }catch {
                print("Error \(error.localizedDescription)")
            }
        } else {
            try! Disk.save(category, to: .documents, as: folder)
        }
//        print("CARD SAVED")
//        let url = try! Disk.url(for: category.title, in: .documents)
//        print("FILE URL \(url)")
    }
    
    func removeCard(card: Card) {
        if Disk.exists(card.categoryTitle, in: .documents) {
            guard var fetched = self.fetchCards(folder: card.categoryTitle) else {return}
            guard let fetchedCard = fetched.first(where: {$0.text == card.text}) else {return}
            fetched.removeAll(where: {$0.text == fetchedCard.text})
            try! Disk.save(fetched, to: .documents, as:  card.categoryTitle)
            print("CARD REMOVED")
        }
    }
    
    func fetchCards(folder: String) -> [Card]? {
        var retrievedCards = [Card] ()
        if Disk.exists(folder, in: .documents) {
            do {
                let cards =  try Disk.retrieve(folder, from: .documents, as: [Card].self)
                retrievedCards = cards
            }catch {
            
            }
        }
        return retrievedCards
    }
    
    func chekIfSaved(category: Category) -> Bool{
        let folder = favoriteString + category.title
         let fetchedCategory = self.fetchSavedCategory(name: folder)
        guard fetchedCategory != nil else {
            return false
        }
        if  fetchedCategory!.items.contains(where: {$0 == category.items.first}) {
            print("TRUE")
            return true
        }
       return false
    }
    
    func fetchSavedCategory(name: String) -> Category? {
        var result : Category?
        if Disk.exists(favoriteString, in: .documents) {
                do {
                    let categories =  try Disk.retrieve(name, from: .documents, as: Category.self)
                    result = categories
                }catch {
                    print("Error \(error.localizedDescription)")
                }
            }
        return result
    }
    
    
    func fetchCategories(name: String) -> [Category] {
        var result = [Category]()
        if Disk.exists(favoriteString, in: .documents) {
                do {
                    let categories =  try Disk.retrieve(name, from: .documents, as: [Category].self)
                    result = categories
                }catch {
                    print("Error \(error.localizedDescription)")
                }
            }
        return result
    }
    
    func fetchFavorites() -> [Category] {
        var result = [Category]()
        if Disk.exists(favoriteString, in: .documents) {
            for folder in folders {
                let folder =  favoriteString + folder
                do {
                    let category =  try Disk.retrieve(folder, from: .documents, as: Category.self)
                    result.append(category)
                }catch {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
        return result

        
        
        
        
        
    }
    
    func fetchSavedCategories() -> [[Category]] {
        var result = [[Category]] ()
        for folder in folders {
            let folder =  favoriteString + folder
            let fetched = self.fetchCategories(name: folder)
            result.append(fetched)
            result.removeAll(where: {$0.isEmpty})
        }
        return result
    }
    
    
    func removeCategory(category: Category){
        let folder = favoriteString + category.title
        
        if Disk.exists(folder, in: .documents) {
            guard var fetchedResult = self.fetchSavedCategory(name: folder) else {return}
            guard let query = category.items.first else {return}
            let filterResult = fetchedResult.items.filter({$0 == query})//fetchedResult!.items(where: {$0 == query})
            fetchedResult.items.removeAll(where: {$0 == filterResult.first})
            try! Disk.save(fetchedResult, to: .documents, as: folder)
            // Remove folder if Empty
            if fetchedResult.items.isEmpty {
                let fileUrl = try! Disk.url(for: folder, in: .documents)
                try! Disk.remove(fileUrl)
            }
        }
    }

}

struct Card: Codable {
    let text : String
    let categoryTitle: String
    let imageString: String
    let color: String
}
