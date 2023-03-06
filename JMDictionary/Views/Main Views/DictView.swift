//
//  DictView.swift
//  JDictionary
//
//  Created by Kovs on 23.02.2023.
//

import SwiftUI

struct DictView: View {
    
    static let dictTag: String? = "dict"
    // test comment
    // test comment 2
    // test comment 3
    
    @EnvironmentObject var jMDictData: JMDictData
    var data: JMDictionary = JMDictData().dictionaryData
    
    var body: some View {
        List {
            ForEach(data.words) { word in
                Text(word.kanji?.first?.text ?? "none")
            }
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
