//
//  Item-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Kovs on 17.02.2023.
//

import Foundation

extension Word {
    
    enum SortOrder {
        case optimized, title, creationDate
    }
    
    var wordTitle: String {
        title ?? NSLocalizedString("New Item", comment: "Create a new word")
    }
    
    var wordDetail: String {
        detail ?? ""
    }
    
    var wordCreationDate: Date {
        creationDate ?? Date()
    }
    
    static var example: Word {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let word = Word(context: viewContext)
        word.title = "Example title"
        word.detail = "this is an example item"
        word.priority = 3
        word.creationDate = Date()
        
        return word
    }
    
}
