//
//  CircularView.swift
//  JMDictionary
//
//  Created by Eugene Kovs on 22.09.2023.
//

import SwiftUI

struct CircularView: View {
    @ObservedObject var group: Group
    
    var body: some View {
        
        HStack {
            ZStack {
                circleView()
            } // ZStack
            .frame(width: 45, height: 45)
            .padding(10)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(group.groupTitle)
                    .bold()
                Text("\(group.groupItems.count) words")
            }
        }
        .padding(.bottom, 10)
        .accessibilityElement(children: .combine)
    }
    
    @ViewBuilder func circleView() -> some View {
        Circle()
            .stroke(
                Color(group.groupColor).opacity(0.5),
                lineWidth: 20
            )
        Circle()
            .trim(from: 0, to: group.completionAmount)
            .stroke(
                Color(group.groupColor),
                style: StrokeStyle(
                    lineWidth: 20,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(-90))
            .animation(.easeOut, value: group.completionAmount)
    }
}

struct CircularViewPreview: PreviewProvider {
    static var previews: some View {
        CircularView(group: Group.example)
            .frame(width: 200, height: 200)
    }
}
