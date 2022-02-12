import SwiftUI

struct BulkEditQuotesFormView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    var quotes: Set<Quote>

    @State private var replaceAuthorFirstName: Bool = false
    @State private var authorFirstName: String = ""
    @State private var replaceAuthorLastName: Bool = false
    @State private var authorLastName: String = ""
    @State private var replaceWork: Bool = false
    @State private var work: String = ""
    @State private var editTags: Bool = false
    @State private var tagsEditMode: EditMode = EditMode.replace
    @State private var tags: String = ""
    @State private var changeStyle: Bool = false
    @State private var displayQuotationMarks: Bool = true
    @State private var displayAuthor: Bool = true
    @State private var displayWork: Bool = true
    @State private var displayAuthorAndWorkOnNewLine: Bool = true

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("AUTHOR")) {
                    Toggle(isOn: $replaceAuthorFirstName) { Text("Replace author first name") }
                        .tint(.accentColor)
                    if replaceAuthorFirstName {
                        TextField("First Name", text: $authorFirstName).lineLimit(1)
                    }
                    Toggle(isOn: $replaceAuthorLastName) { Text("Replace author last name") }
                        .tint(.accentColor)
                    if replaceAuthorLastName {
                        TextField("Last Name", text: $authorLastName).lineLimit(1)
                    }
                }
                Section(header: Text("WORK")) {
                    Toggle(isOn: $replaceWork) { Text("Replace work") }
                        .tint(.accentColor)
                    if replaceWork {
                        TextField("Work", text: $work).lineLimit(1)
                    }
                }
                Section(header: Text("TAGS")) {
                    Toggle(isOn: $editTags) { Text("Edit tags") }
                        .tint(.accentColor)
                    if editTags {
                        TextField("Tags (comma-separated)", text: $tags).lineLimit(1)
                        Picker("Mode", selection: $tagsEditMode) {
                            Text("Replace").tag(EditMode.replace)
                            Text("Add").tag(EditMode.add)
                            Text("Remove").tag(EditMode.remove)
                        }.pickerStyle(.segmented)
                    }
                }
                Section(header: Text("STYLE")) {
                    Toggle(isOn: $changeStyle) { Text("Change style") }
                        .tint(.accentColor)
                    if changeStyle {
                        Toggle(isOn: $displayQuotationMarks) { Text("Display quotation marks") }
                        .tint(.accentColor)
                        Toggle(isOn: $displayAuthor) { Text("Display author") }
                        .tint(.accentColor)
                        Toggle(isOn: $displayWork) { Text("Display work") }
                        .tint(.accentColor)
                        Toggle(isOn: $displayAuthorAndWorkOnNewLine) { Text("Display author and work on new line") }
                        .tint(.accentColor)
                    }
                }
                Section {
                    Button(
                        action: {
                            DatabaseFunctions.bulkEditQuotes(
                                context: context,
                                quotes: quotes,
                                newAuthorFirstName: replaceAuthorFirstName ? authorFirstName : nil,
                                newAuthorLastName: replaceAuthorLastName ? authorLastName : nil,
                                newWork: replaceWork ? work : nil,
                                tags: editTags ? tags : nil,
                                tagsMode: tagsEditMode,
                                displayQuotationMarks: changeStyle ? displayQuotationMarks : nil,
                                displayAuthor: changeStyle ? displayAuthor : nil,
                                displayWork: changeStyle ? displayWork : nil,
                                displayAuthorAndWorkOnNewLine: changeStyle ? displayAuthorAndWorkOnNewLine : nil
                            )
                            dismiss()
                        },
                        label: { SubmitButtonTextView() }
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
                        CancelButtonView(dismiss: dismiss)
                    }
                }
            )
        }
    }
}
