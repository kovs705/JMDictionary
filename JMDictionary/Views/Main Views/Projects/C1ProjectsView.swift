//
//  C1ProjectsView.swift
//  JMDictionary
//
//  Created by Eugene Kovs on 22.09.2023.
//

import SwiftUI
import CoreData

struct C1ProjectsView: View {
    
    @StateObject var C1ProjectsVM: C1ProjectsVM
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        
        Text("Test")
        
    }
}

struct C1ProjectsViewPreview: PreviewProvider {
    static let dataController = DataController.preview
    
    static var previews: some View {
        C1ProjectsView(C1ProjectsVM: C1ProjectsVM(showClosedProjects: false))
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
