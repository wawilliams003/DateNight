//
//  ContentView.swift
//  DateNight
//
//  Created by Wayne Williams on 8/14/23.
//

//
//  ContentView.swift
//  iOS-ChatGPT
//
//  Created by Mohammad Azam on 3/14/23.
//

import SwiftUI
import OpenAISwift

struct ContentView: View {
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        
        
        NavigationStack {
            MainView()
                .environmentObject(SwiftUIModel())
                .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
            
                
                .sheet(isPresented: $isPresented, content: {
                    NavigationStack {
                        HistoryView()
                            .navigationTitle("History")
                            .environmentObject(SwiftUIModel())
                            .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
                    }
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isPresented = true
                        } label: {
                            Text("Show History")
                        }
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SwiftUIModel())
    }
}
