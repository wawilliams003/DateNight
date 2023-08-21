//
//  Model.swift
//  ChatGPTApp
//
//  Created by Mohammad Azam on 3/14/23.
//

import Foundation

@MainActor
class SwiftUIModel: ObservableObject {
    //static let shared = SwiftUIModel()
    @Published var queries: [Query] = []
    @Published var query = Query(question: "", answer: "")
    
    func saveQuery(_ query: Query) throws {
        
        let viewContext = CoreDataManager.shared.persistentContainer.viewContext
        let historyItem = HistoryItem(context: viewContext)
        historyItem.question = query.question
        historyItem.answer = query.answer
        historyItem.dateCreated = Date()
        try viewContext.save()
    }
    
}
