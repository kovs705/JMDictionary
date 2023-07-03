//
//  HomeView.swift
//  UltimatePortfolio
//
//  Created by Kovs on 17.02.2023.
//

import SwiftUI

struct HomeView: View {
    
    // testing commits
    
    static let tag: String? = "Home"
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Add Data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
