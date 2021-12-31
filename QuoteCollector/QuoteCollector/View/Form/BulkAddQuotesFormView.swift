import SwiftUI

struct BulkAddQuotesFormView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    var quoteCollection: QuoteCollection

    @State private var quotes: String = ""
    @State private var fallbackAuthorFirstName: String = ""
    @State private var fallbackAuthorLastName: String = ""
    @State private var tags: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("QUOTES")) {
                    VStack(alignment: .leading, spacing: 5) {
                        InstructionsTextView(
                            text: (
                                "Enter or paste a list of quotes below, with one quote " +
                                "per line and authors attributed after two long dashes."
                            )
                        )
                        Spacer()
                        ExampleTextView(text: "Example:")
                        ExampleTextView(
                            text: (
                                "A good quote. ——Author Name\n" +
                                "Another good one. ——Author Name\n" +
                                "And an anonymous one.\n" +
                                "..."
                            ),
                            small: true,
                            italic: true
                        )
                    }.padding([.top, .bottom], 10)
                    TextEditor(text: $quotes)
                }
                Section(header: Text("FALLBACK AUTHOR (optional)")) {
                    VStack(alignment: .leading) {
                        InstructionsTextView(
                            text: (
                                "Specify a fallback author to assign to input " +
                                "quotes that have no attributed author."
                            )
                        )
                    }.padding([.top, .bottom], 10)
                    TextField("First Name", text: $fallbackAuthorFirstName)
                        .lineLimit(1)
                    TextField("Last Name", text: $fallbackAuthorLastName)
                        .lineLimit(1)
                }
                Section(header: Text("TAGS (optional)")) {
                    VStack(alignment: .leading) {
                        InstructionsTextView(
                            text: (
                                "Specify any tags that you want to " +
                                "apply to all input quotes."
                            )
                        )
                    }.padding([.top, .bottom], 10)
                    TextField("Tags (comma-separated)", text: $tags)
                        .lineLimit(1)
                }
                Section {
                    Button(
                        action: {
                            DatabaseFunctions.bulkAddQuotes(
                                context: context,
                                quoteCollection: quoteCollection,
                                quotes: quotes,
                                fallbackAuthorFirstName: fallbackAuthorFirstName,
                                fallbackAuthorLastName: fallbackAuthorLastName,
                                tags: tags
                            )
                            dismiss()
                        },
                        label: { SubmitButtonTextView() }
                    )
                }
            }
            .navigationTitle("Add Quotes")
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
