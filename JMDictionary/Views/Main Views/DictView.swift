//
//  DictView.swift
//  JDictionary
//
//  Created by Kovs on 23.02.2023.
//

import SwiftUI

struct DictView: View {
    static let dictTag: String? = "dict"
    
    @ObservedObject var jMDictData = JMDictData()
    
    var body: some View {
        NavigationView {
            if jMDictData.isLoading {
                // Show loading view while data is being loaded
                Text("Loading...")
            } else if let data = jMDictData.dictionaryData {
                // Show list view when data is loaded
                List {
                    ForEach(data.words) { word in
                        Text(word.kanji?.first?.text ?? word.kana?.first?.text ?? "None")
                    }
                }
            } else {
                // Show error view if loading failed
                Text("Failed to load data.")
            }
        }
        .onAppear {
            jMDictData.loadData(filename: JMDictVersions.eng)
        }
    }
}

//struct DictView_Previews: PreviewProvider {
//    static var jm = JMDictData()
//
//    static var previews: some View {
//        DictView(data: jm.dictionaryData.first!)
//            .environmentObject(JMDictData())
//    }
//}
