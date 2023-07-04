//
//  HomeView.swift
//  UltimatePortfolio
//
//  Created by Kovs on 17.02.2023.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    // testing commits
    
    static let tag: String? = "Home"
    @EnvironmentObject var dataController: DataController
    
    @FetchRequest(entity: Group.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Group.title, ascending: true)], predicate: NSPredicate(format: "closed = false")) var groups: FetchedResults<Group>
    
    let words: FetchRequest<Word>
    
    var groupRows: [GridItem] {
        [GridItem(.fixed(100))]
    }
    
    init() {
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        request.predicate = NSPredicate(format: "completed = false")
        
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Word.priority, ascending: false)
        ]
        
        request.fetchLimit = 10
        words = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: groupRows) {
                            ForEach(groups) { group in
                                VStack(alignment: .leading) {
                                    Text("\(group.groupItems.count) groups")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text(group.groupTitle)
                                        .font(.title2)
                                    
                                    ProgressView(value: group.completionAmount)
                                        .tint(Color(group.groupColor))
                                }
                                // Vstack
                                .padding()
                                .background(BlurView(style: .regular))
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 5)
                            }
                        }
                        // LazyHGrid
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    // scrollView inside
                    
                    VStack(alignment: .leading) {
                        list("Up next", for: words.wrappedValue.prefix(3))
                        list("More to explore", for: words.wrappedValue.dropFirst(3))
                    }.padding(.horizontal)
                }
            }
            // ain ScrollView
            
            
            .navigationTitle("Home")
        }
    }
    
    @ViewBuilder func list(_ title: String, for words: FetchedResults<Word>.SubSequence) -> some View {
        if words.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
            
            ForEach(words) { word in
                NavigationLink(destination: EditItemView(word: word)) {
                    HStack(spacing: 20) {
                        Circle()
                            .stroke(Color(word.group?.groupColor ?? "Light Blue"), lineWidth: 3)
                            .frame(width: 44, height: 44)
                        
                        VStack(alignment: .leading) {
                            Text(word.wordTitle)
                                .font(.title2)
                                .foregroundColor(.primary)
                            
                            if word.wordDetail.isEmpty == false {
                                Text(word.wordDetail)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    // HStack
                    .padding()
                    .background(BlurView(style: .regular))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                // navigationLink
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
