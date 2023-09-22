//
//  ContentView.swift
//  JMDictionary
//
//  Created by Kovs on 03.03.2023.
//

import SwiftUI

struct ContentView: View {
    
    @SceneStorage("selectedView") var selectedView: String?
    
    var body: some View {
        
            TabView(selection: $selectedView) {
                MainView()
//                HomeView()
//                    .tag(HomeView.tag )
                    .tabItem {
                        Image(systemName: Icons.house)
                        Text("Home")
                    }
                
                DictView()
                    .tag(DictView.dictTag)
                    .tabItem {
                        Image(systemName: Icons.dict)
                        Text("Dictionary")
                    }
                
                ProjectsView(showClosedProjects: false)
                    .tag(ProjectsView.openTag)
                    .tabItem {
                        Image(systemName: Icons.bulletList)
                        Text("Open")
                    }
                
                ProjectsView(showClosedProjects: true)
                    .tag(ProjectsView.closedTag)
                    .tabItem {
                        Image(systemName: Icons.checkmark)
                        Text("Closed")
                    }
            }
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var dataController = DataController.preview
        
        static var previews: some View {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
