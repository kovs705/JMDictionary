//
//  DataController.swift
//  UltimatePortfolio
//
//  Created by Kovs on 17.02.2023.
//

import CoreData
import SwiftUI

// test comment

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    static var preview: DataController = {
       let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        
        return dataController
    }()
    
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let group = Group(context: viewContext)
            group.title = "Group \(i)"
            group.words = []
            group.creationDate = Date()
            group.closed = Bool.random()
            
            for j in 1...5 {
                let word = Word(context: viewContext)
                word.title = "Word \(j)"
                word.creationDate = Date()
                word.completed = Bool.random()
                word.group = group
                word.priority = Int16.random(in: 1...3)
            }
        }
        
        try viewContext.save()
    }
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
            (try? container.viewContext.count(for: fetchRequest)) ?? 0
        }
    
    func hasEarned(award: Award) -> Bool {
            switch award.criterion {
            case "items":
                let fetchRequest: NSFetchRequest<Word> = NSFetchRequest(entityName: "Word")
                let awardCount = count(for: fetchRequest)
                return awardCount >= award.value

            case "complete":
                let fetchRequest: NSFetchRequest<Word> = NSFetchRequest(entityName: "Word")
                fetchRequest.predicate = NSPredicate(format: "completed = true")
                let awardCount = count(for: fetchRequest)
                return awardCount >= award.value

            default:
    //            fatalError("Unknown award criterion \(award.criterion).")
                return false
            }
        }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Word.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Word.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
        
    }
    
}
