//
//  EditProjectView.swift
//  UltimatePortfolio
//
//  Created by Kovs on 19.02.2023.
//

import SwiftUI

struct EditProjectView: View {
    let group: Group

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(project: Group) {
        self.group = project

        _title = State(wrappedValue: project.groupTitle)
        _detail = State(wrappedValue: project.groupDetail)
        _color = State(wrappedValue: project.groupColor)
    }

    func update() {
        group.title = title
        group.detail = detail
        group.color = color
    }

    func delete() {
        dataController.delete(group)
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        Form(content: {
            Section(header: Text("Basic Settings")) {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            }

            Section(header: Text("Custom project color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Group.colors, id: \.self) { color in
                        colorButton(for: color)
                    }
                }
            }

            Section(header: Text("Closing a project moves it from the Open tab to the Closed tab; Deleting it removes the project completely.")) {
                Button(group.closed ? "Reopen this project" : "Close this project") {
                    group.closed.toggle()
                    update()
                }

                Button("Delete this project") {
                    showingDeleteConfirm = true
                }
                .accentColor(.red)
            }
        })
        .navigationTitle("Edit Project")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text("Delete project?"),
                        message: Text("Are you sure you want to delete this project and all of its items?"),
                        primaryButton: .destructive(Text("Delete"), action: delete),
                        secondaryButton: .cancel())
        }
    }

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        EditProjectView(project: Group.example)
            .environmentObject(dataController)
    }
}
