import SwiftUI

struct BulkEditQuotesView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation

    var quotes: Set<Quote>

    @State private var replaceAuthorFirstName: Bool = false
    @State private var authorFirstName: String = ""
    @State private var replaceAuthorLastName: Bool = false
    @State private var authorLastName: String = ""
    @State private var editTags: Bool = false
    @State private var tagsEditMode: EditMode = EditMode.replace
    @State private var tags: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("AUTHOR (optional)")) {
                    Toggle(isOn: $replaceAuthorFirstName) { Text("Replace author first name") }
                        .tint(.accentColor)
                    if replaceAuthorFirstName {
                        TextField("First Name", text: $authorFirstName)
                            .lineLimit(1)
                    }
                    Toggle(isOn: $replaceAuthorLastName) { Text("Replace author last name") }
                        .tint(.accentColor)
                    if replaceAuthorLastName {
                        TextField("Last Name", text: $authorLastName)
                            .lineLimit(1)
                    }
                }
                Section(header: Text("TAGS (optional)")) {
                    Toggle(isOn: $editTags) { Text("Edit tags") }
                        .tint(.accentColor)
                    if editTags {
                        TextField("Tags (comma-separated)", text: $tags)
                            .lineLimit(1)
                        Picker("Mode", selection: $tagsEditMode) {
                            Text("Replace").tag(EditMode.replace)
                            Text("Add").tag(EditMode.add)
                            Text("Remove").tag(EditMode.remove)
                        }.pickerStyle(.segmented)
                    }
                }
                Section {
                    Button(
                        action: {
                            DatabaseFunctions.editQuotes(
                                context: context,
                                quotes: quotes,
                                newAuthorFirstName: replaceAuthorFirstName ? authorFirstName : nil,
                                newAuthorLastName: replaceAuthorLastName ? authorLastName : nil,
                                tags: editTags ? tags : nil,
                                tagsMode: tagsEditMode
                            )
                            presentation.wrappedValue.dismiss()
                        },
                        label: { SubmitButtonText() }
                    )
                }
            }
            .navigationTitle(
                "Edit \(quotes.count) " +
                (quotes.count == 1 ? "Quote" : "Quotes")
            )
            .toolbar(
                content: {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { presentation.wrappedValue.dismiss() }
                    }
                }
            )
        }
    }
}
