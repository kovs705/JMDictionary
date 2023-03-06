//
//  ProjectHeaderView.swift
//  UltimatePortfolio
//
//  Created by Kovs on 19.02.2023.
//

import SwiftUI

struct ProjectHeaderView: View {
    @ObservedObject var group: Group

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(group.groupTitle)

                ProgressView(value: group.completionAmount)
                    .accentColor(Color(group.groupColor))
            }

            Spacer()

            NavigationLink(destination: EditProjectView(project: group)) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
        }
        .padding(.bottom, 10)
        .accessibilityElement(children: .combine)
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(group: Group.example)
    }
}
