//
//  ItemRowView.swift
//  UltimatePortfolio
//
//  Created by Kovs on 18.02.2023.
//

import SwiftUI

struct ItemRowView: View {
    
    @ObservedObject var group: Group
    @ObservedObject var word: Word

    var icon: some View {
        if word.completed {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color(group.groupColor))
        } else if word.priority == 3 {
            return Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(group.groupColor))
        } else {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }

    var label: Text {
        if word.completed {
            return Text("\(word.wordTitle), completed.")
        } else if word.priority == 3 {
            return Text("\(word.wordTitle), high priority.")
        } else {
            return Text(word.wordTitle)
        }
    }

    var body: some View {
        NavigationLink(destination: EditItemView(word: word)) {
            Label {
                Text(word.wordTitle)
            } icon: {
                icon
            }
            .accessibilityLabel(label)
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ItemRowView(group: Group.example, word: Word.example)
            ItemRowView(group: Group.example, word: Word.example)
        }
    }
}
