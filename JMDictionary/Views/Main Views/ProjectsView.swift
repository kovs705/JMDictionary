//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Kovs on 17.02.2023.
//

import SwiftUI
import CoreData

struct ProjectsView: View {
    
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    let showClosedProjects: Bool
    let groups: FetchRequest<Group>
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showingSortOrder = false
    
    @State private var sortOrder = Word.SortOrder.optimized
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        
        groups = FetchRequest<Group>(entity: Group.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Group.creationDate, ascending: false)
        ], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
        
        // %d - placeholder, so this is a placeholder for showClosedProjects boolean
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(groups.wrappedValue) { group in
                    Section(header: ProjectHeaderView(group: group)) {
                        ForEach(items(for: group)) { word in
                            ItemRowView(group: group, word: word)
                        }
                        .onDelete { offsets in
                            let allItems = group.groupItems
                            
                            for offset in offsets {
                                let word = allItems[offset]
                                dataController.delete(word)
                            }
                            
                            dataController.save()
                        }
                        
                        if showClosedProjects == false {
                            Button {
                                withAnimation {
                                    let word = Word(context: managedObjectContext)
                                    word.group = group
                                    word.completed = false
                                    word.creationDate = Date()
                                    dataController.save()
                                }
                            } label: {
                                Label("Add New Item", systemImage: "plus")
                            }
                        }
                    }
                    .actionSheet(isPresented: $showingSortOrder) {
                        ActionSheet(title: Text("Sort items"), message: nil, buttons: [
                            .default(Text("Optimized")) { sortOrder = .optimized },
                            .default(Text("Creation Date")) { sortOrder = .creationDate },
                            .default(Text("Title")) { sortOrder = .title },
                            .cancel()
                        ])
                    }
                }
                
//                Spacer().frame(height: 75)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showClosedProjects == false {
                        Button{
                            withAnimation {
                                let group = Group(context: managedObjectContext)
                                group.closed = false
                                group.creationDate = Date()
                                dataController.save()
                            }
                        } label: {
                            Label("Add Project", systemImage: "plus")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSortOrder.toggle()
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
        }
    }
    
    func items(for group: Group) -> [Word] {
        switch sortOrder {
        case .title:
            return group.groupItems.sorted(by: \Word.wordTitle)
        case .creationDate:
            return group.groupItems.sorted(by: \Word.wordCreationDate)
        case .optimized:
            return group.projectItemsDefaultSorted
        }
        
    }
    
    func addItem(to group: Group) {
        withAnimation {
            let word = Word(context: managedObjectContext)
            word.group = group
            word.creationDate = Date()
            dataController.save()
        }
    }
    
}

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
