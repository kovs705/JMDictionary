//
//  Project-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Kovs on 17.02.2023.
//

import Foundation

extension Group {
    
    static let colors = [
            "Pink",
            "Purple",
            "Red",
            "Orange",
            "Gold",
            "Green",
            "Teal",
            "Light Blue",
            "Dark Blue",
            "Midnight",
            "Dark Gray",
            "Gray"
        ]
    
    var groupTitle: String {
        title ?? NSLocalizedString("New Project", comment: "Create a new group")
    }
    
    var groupDetail: String {
        detail ?? ""
    }
    
    var groupColor: String {
        color ?? "Light Blue"
    }
    
    var groupItems: [Word] {
        words?.allObjects as? [Word] ?? []
    }
    
    var projectItemsDefaultSorted: [Word] {
        
        return groupItems.sorted { first, second in
            if first.completed == false {
                if second.completed == true {
                    return true
                }
            } else if first.completed == true {
                if second.completed == false {
                    return false
                }
            }
            
            // if both objects are completed or not:
            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
                return false
            }
            
            // both completed or not and have the same priority:
            return first.wordCreationDate < second.wordCreationDate
        }
    }
    
    var completionAmount: Double {
        let originalItems = words?.allObjects as? [Word] ?? []
        guard originalItems.isEmpty == false else { return 0 }
        
        let completedWords = originalItems.filter(\.completed)
        // set to true every item which is completed { $0.completed == true }
        return Double(completedWords.count) / Double(originalItems.count)
    }
    
    static var example: Group {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let group = Group(context: viewContext)
        group.title = "Example project"
        group.detail = "this is an example group"
        group.closed = true
        group.creationDate = Date()
        
        return group
    }
    
    func projectItems<Value: Comparable>(sortedBy keyPath: KeyPath<Word, Value>) -> [Word] {
        // a func with some sort of a Value which is Comparable, sorted by a keyPath, and this keyPath will point to Item object and our value
        groupItems.sorted {
            $0[keyPath: keyPath] < $1[keyPath: keyPath]
        }
    }
}
