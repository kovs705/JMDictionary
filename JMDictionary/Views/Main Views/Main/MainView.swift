//
//  MainView.swift
//  JMDictionary
//
//  Created by Eugene Kovs on 22.09.2023.
//

import SwiftUI
import CoreData
import WeatherKit

struct MainView: View {
    
    @EnvironmentObject var dataController: DataController
    @FetchRequest(entity: Group.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Group.title, ascending: true)], predicate: NSPredicate(format: "closed = false")) var groups: FetchedResults<Group>
    
    let words: FetchRequest<Word>
    
    var groupRows: [GridItem] {
        [GridItem(.flexible(minimum: 100, maximum: 130))]
    }
    
    var wordRows: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 130)),
        GridItem(.adaptive(minimum: 100, maximum: 130))]
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
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            
            ScrollView {
                HStack {
                    Text("Home page")
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle)
                        .padding(.top, 10)
                        .bold()
                    Spacer()
                }
                .padding()
                headerView()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.1))
                        .background(BlurView(style: .regular))
                        .frame(width: .infinity, height: .infinity)
                    
                    LazyVGrid(columns: wordRows) {
                        ForEach(words.wrappedValue, id: \.self) { word in
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .background(Color.clear)
                                    .frame(height: 40)
                                Text(word.wordTitle)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        .background(BlurView(style: .regular))
                    }
                    .frame(height: .infinity)
                }
                .background(Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(height: .infinity)
                .padding(.top, 40)
                .padding(.horizontal, 20)
                
            }
            
        }
        .background(Image(ImageResource.background2)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all))
        
    }
    
    @ViewBuilder func headerView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Favorites")
                .fontWeight(.semibold)
                .font(.title2)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: groupRows, spacing: 20) {
                    ForEach(groups) { group in
                        CircularView(group: group)
                    }
                }
                .padding(.horizontal)
            }
        }
        .cornerRadius(10)
    }
}

struct MainViewPreview: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        MainView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
