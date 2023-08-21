//
//  HistoryView.swift
//  ChatGPTApp
//
//  Created by Mohammad Azam on 3/14/23.
//

import SwiftUI

struct HistoryView: View {
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: true)]) private var historyItemResults: FetchedResults<HistoryItem>
    @EnvironmentObject private var model: SwiftUIModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        
            List(historyItemResults) { historyItem in
                Text(historyItem.question ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        model.query = Query(question: historyItem.question ?? "", answer: historyItem.answer ?? "")
                        print("SELECTED ANSWER\(historyItem.answer ?? "")")
                        #if os(iOS)
                            dismiss()
                        #endif
                    }
            }.frame(maxWidth: .infinity)
        #if os(iOS)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        #endif
            
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(SwiftUIModel())
    }
}
