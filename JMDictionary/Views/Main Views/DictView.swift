//
//  DictView.swift
//  JDictionary
//
//  Created by Kovs on 23.02.2023.
//

import SwiftUI

struct DictView: View {
    @StateObject private var coordinator = JMDictCoordinator()

    var body: some View {
        NavigationStack {
            ScrollView {
                if coordinator.dictionary.isEmpty {
                    VStack(alignment: .center, spacing: 25) {
                        Text("No data")
                            .font(.title)
                        Text("Unzip json file in JSON folder and place it inside xcode!\nBut don't open it, I warned you.")
                    }
                } else  {
                    LazyVStack {
                        ForEach(coordinator.dictionary) { word in
                            HStack {
                                Text((word.kana?.first?.text ?? word.kanji?.first?.text) ?? "Empty")
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .onAppear {
                coordinator.getTheJapaneseData()
            }
            .onDisappear {
                coordinator.clearData()
            }
        }
    }
}
