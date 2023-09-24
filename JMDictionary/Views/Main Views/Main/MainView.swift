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
        [GridItem(.adaptive(minimum: 100, maximum: .infinity)),
         GridItem(.adaptive(minimum: 100, maximum: .infinity)),
         GridItem(.adaptive(minimum: 100, maximum: .infinity))]
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
    
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            
            ScrollViewReader { reader in
                ScrollView {
                    
                    titleHeader()
                    
                    headerView()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.1))
                            .background(BlurView(style: .regular))
                            .frame(width: .infinity, height: .infinity)
                        
                        wordGrid()
                    }
                    .background(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(height: .infinity)
                    .padding(.top, 40)
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading) {
                        list("Up next", for: words.wrappedValue.prefix(3))
                    }.padding(.horizontal)
                    
                    Spacer().frame(height: 75)
                    
                }
                
            }
            .background(Image(colorScheme == .dark ? ImageResource.background1 : ImageResource.background2)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all))
        }
    }
    
    @ViewBuilder func headerView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Favorites")
                    .fontWeight(.semibold)
                    .font(.title2)
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    //
                } label: {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.clear)
                        HStack(spacing: 5) {
                            Spacer()
                            Text("Show more")
                                .font(.subheadline)
                                .foregroundStyle(Color.init(uiColor: .label))
                            Image(systemName: "chevron.right")
                                .font(.subheadline)
                                .foregroundStyle(Color.init(uiColor: .label))
                        }
                        .padding(.horizontal)
                    }
                }
                .frame(width: 140)
                
            }
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
    
    @ViewBuilder func wordGrid() -> some View {
        LazyVGrid(columns: wordRows) {
            ForEach(words.wrappedValue, id: \.self) { word in
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.init(uiColor: .systemBackground))
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
    
    @ViewBuilder func titleHeader() -> some View {
        HStack {
            Text("Home page")
                .multilineTextAlignment(.leading)
                .font(.largeTitle)
                .padding(.top, 10)
                .bold()
            Spacer()
        }
        .padding()
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
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
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
                }
                // navigationLink
            }
        }
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
