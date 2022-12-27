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
    
    func saveCard(card: Card) {
        var cards = [Card]()
        if Disk.exists(card.category, in: .documents){
           // try! Disk.save(card, to: .documents, as: card.category)
            cards.append(card)
            try! Disk.append(cards, to: card.category, in: .documents)
        } else {
            try! Disk.save(card, to: .documents, as: card.category)
        }
        print("CARD SAVED")
//        let url = try! Disk.url(for: card.category, in: .documents)
//        print("FILE URL \(url)")
    }
    
    func removeCard(card: Card) {
        if Disk.exists(card.category, in: .documents) {
            guard var fetched = self.fetchCards(folder: card.category) else {return}
            guard let fetchedCard = fetched.first(where: {$0.text == card.text}) else {return}
            fetched.removeAll(where: {$0.text == fetchedCard.text})
            try! Disk.save(fetched, to: .documents, as:  card.category)
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
    
    func chekIfSaved(card: Card) -> Bool{
        guard let fetchedCards = self.fetchCards(folder: card.category) else {
            return false
        }
        if fetchedCards.contains(where: {$0.text == card.text}) {
            return true
        }
        return false
    }
    
    
}

struct Card: Codable {
    let text : String
    let category: String
}
