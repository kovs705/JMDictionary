//
//  EditItemView.swift
//  UltimatePortfolio
//
//  Created by Kovs on 18.02.2023.
//

import SwiftUI

struct EditItemView: View {
    
    let word: Word
    @EnvironmentObject var dataController: DataController
    
    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool
    
    init(word: Word) {
        self.word = word
        
        _title = State(wrappedValue: word.wordTitle)
        _detail = State(wrappedValue: word.wordDetail)
        _priority = State(wrappedValue: Int(word.priority))
        _completed = State(wrappedValue: word.completed)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Item name", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            }
            
            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority.onChange(update)) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section {
                Toggle("Mark completed", isOn: $completed.onChange(update))
            }
        }
        .navigationTitle("Edit Item")
        .onDisappear(perform: dataController.save)
    }
    
    func update() {
        word.group?.objectWillChange.send()
        
        word.title = title
        word.detail = detail
        word.priority = Int16(priority)
        word.completed = completed
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(word: Word.example)
    }
}
