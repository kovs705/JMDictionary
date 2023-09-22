//
//  C1ProjectsVM.swift
//  JMDictionary
//
//  Created by Eugene Kovs on 22.09.2023.
//

import SwiftUI

@MainActor
class C1ProjectsVM: ObservableObject {
    
    var showClosedProjects: Bool
    let groups: FetchRequest<Group>
    
    @Published var showingSortOrder = false
    @Published var sortOrder = Word.SortOrder.optimized
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        
        groups = FetchRequest<Group>(entity: Group.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Group.creationDate, ascending: false)
        ], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }
    
}
