//
//  JMDictionaryApp.swift
//  JMDictionary
//
//  Created by Kovs on 03.03.2023.
//

import SwiftUI
import CoreData

@main
struct JMDictionaryApp: App {
    
    @StateObject var dataController: DataController
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: save)
        }
    }
    
    func save(_ note: Notification) {
        dataController.save()
    }
}
