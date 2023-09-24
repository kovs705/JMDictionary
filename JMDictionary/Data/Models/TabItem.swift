//
//  TabItem.swift
//  JMDictionary
//
//  Created by Eugene Kovs on 24.09.2023.
//

import SwiftUI

struct TabItem: Identifiable, CaseIterable {
    
    var id = UUID()
    var text: String
    var icon: String
    
    var tab: SelectedTab
    var color: Color
    
    static var allCases: [TabItem] = [
        TabItem(text: "Home", icon: Icons.house, tab: .home, color: .purple),
        TabItem(text: "Dictionary", icon: Icons.dict, tab: .dict, color: .teal) ,
        TabItem(text: "Tasks", icon: Icons.checkmark, tab: .tasks, color: .orange)
    ]
}

enum SelectedTab {
    case home
    case dict
    case tasks
}

struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
