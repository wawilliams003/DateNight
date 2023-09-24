//
//  MainView.swift
//  ChatGPTApp
//
//  Created by Mohammad Azam on 3/14/23.
//

import SwiftUI
import OpenAISwift

struct Query: Identifiable, Hashable {
    let id = UUID()
    let question: String
    let answer: String
}

struct MainView: View {
    
    @State private var chatText: String = ""
    @EnvironmentObject private var model: SwiftUIModel
    //@StateObject var model = SwiftUIModel()
    @State private var isSearching: Bool = false
    
    @State var keyboardYOffset: CGFloat = 0
    
    //let keyString = ("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")
    var openAI =  OpenAISwift(config: OpenAISwift.Config.makeDefaultOpenAI(apiKey: ""))
    //let open = OpenAISwift(config: OpenAISwift.Config)
    
    
    private func performSearch() {
        
        openAI.sendCompletion(with: chatText, maxTokens: 500) { result in
            switch result {
                case .success(let success):
                    print(success)
                print("CHAT GOT Success\(success)")
                    // OpenAI<TextResult>(object: nil, model: nil, choices: nil, usage: nil, data: nil)
                    let answer = success.choices?.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    let query = Query(question: chatText, answer: answer)
                    DispatchQueue.main.async {
                        model.queries.append(query)
                    }
                    // save into the database
                    do {
                        try model.saveQuery(query)
                    } catch {
                        print(error)
                        print(error.localizedDescription)
                    }
                    
                    chatText = ""
                isSearching = false
                    
                case .failure(let failure):
                isSearching = false
                    print("CHAT GOT FAILURE\(failure)")
                    print(failure.localizedDescription)
            }
        }
    }
    
    private var isFormValid: Bool {
        !chatText.isEmptyOrWhiteSpace
    }
    
    var body: some View {
        
            VStack {
                ScrollView {
                    ScrollViewReader { proxy in
                        ForEach(model.queries) { query in
                            VStack(alignment: .leading) {
                                Text(query.question)
                                    .fontWeight(.bold)
                                Text(query.answer)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.bottom], 10)
                            .id(query.id)
                            .listRowSeparator(.hidden)
                        }.listStyle(.plain)
                            .onChange(of: model.queries) { query in
                                if !model.queries.isEmpty {
                                    let lastQuery = model.queries[model.queries.endIndex - 1]
                                    withAnimation {
                                        proxy.scrollTo(lastQuery.id, anchor: .bottom)
                                    }
                                }
                            }
                    }
                }.padding()
                    .hideKeyboardWhenTappedAround()
                
                Spacer()
                HStack {
                    TextField("Search...", text: $chatText)
                        .textFieldStyle(.roundedBorder)
                    Button {
                        // action
                        isSearching = true
                        performSearch()
                    } label: {
                        Image(systemName: "paperplane.circle.fill")
                            .font(.title)
                            .rotationEffect(Angle(degrees: 45))
                    }.buttonStyle(.borderless)
                        .tint(.blue)
                    .disabled(!isFormValid)
                }.padding()
            .navigationTitle("Chat")
            }.onChange(of: model.query) { query in
                model.queries.append(query)
            }
            .overlay(alignment: .center) {
                if isSearching {
                    ProgressView("Searching....")
                }
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(SwiftUIModel())
    }
}
