//
//  TabBar.swift
//  JMDictionary
//
//  Created by Eugene Kovs on 24.09.2023.
//

import SwiftUI

struct TabBar: View {
    
    @State private var selectedTab: SelectedTab = .home
    @State private var color: Color = .purple
    @State private var tabItemWidth: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ZStack {
                switch selectedTab {
                case .home:
                    MainView()
                case .dict:
                    DictView()
                case .tasks:
                    ProjectsView(showClosedProjects: false)
                    // TODO: - переделать
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            buttomTabBar
        }
    }
    
    var buttomTabBar: some View {
        buttons
            .background(
                circleBackground
            )
            .overlay(
                lineBackground
            )
        
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
    }
    
    @ViewBuilder func tabItem(tabItem: TabItem) -> some View {
        VStack(spacing: 0) {
            Image(systemName: tabItem.icon)
                .symbolVariant(.fill)
                .font(.body.bold())
                .frame(width: 80, height: 29)
            Text(tabItem.text)
                .font(.caption2)
        }
    }
    
    var buttons: some View {
        HStack {
            ForEach(TabItem.allCases) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                        selectedTab = tab.tab
                        color = tab.color
                    }
                }, label: {
                    tabItem(tabItem: tab)
                        .frame(maxWidth: .infinity)
                })
                .foregroundStyle(selectedTab == tab.tab ? .primary : .secondary)
                .blendMode(selectedTab == tab.tab ? .overlay : .normal)
                .overlay(
                    GeometryReader { proxy in
                        Color.clear.preference(key: TabPreferenceKey.self, value: proxy.size.width)
                    }
                )
                .onPreferenceChange(TabPreferenceKey.self) { value in
                    tabItemWidth = value
                }
                
            }
        }
        .padding(.horizontal)
        .padding(.top, 14)
        .frame(height: 88, alignment: .top)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
    
    var circleBackground: some View {
        HStack {
            if selectedTab == .tasks { Spacer() }
            if selectedTab == .dict { Spacer() }
            
            Circle()
                .fill(color)
                .frame(width: tabItemWidth)
            
            if selectedTab == .home { Spacer() }
            if selectedTab == .dict { Spacer() }
            
        }
        .padding(.horizontal)
    }
    
    var lineBackground: some View {
        HStack {
            if selectedTab == .tasks { Spacer() }
            if selectedTab == .dict { Spacer() }
            
            RoundedRectangle(cornerRadius: 5)
                .fill(color)
                .frame(width: 40, height: 3)
                .frame(width: tabItemWidth)
                .frame(maxHeight: .infinity, alignment: .top)
            
            if selectedTab == .home { Spacer() }
            if selectedTab == .dict { Spacer() }
            
        }
            .padding(.horizontal)
    }
}

// MARK: - Preview
struct TabBarPreview: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        TabBar()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
