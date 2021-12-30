import SwiftUI

struct InstructionsText: View {
    var text: String

    var body: some View {
        Text(text).font(.callout).bold()
    }
}

struct ExampleText: View {
    var text: String
    var italic: Bool = false

    var body: some View {
        if italic { Text(text).font(.callout).italic() }
        else { Text(text).font(.callout) }
    }
}

struct BulkAddQuotesView: View {
    @State private var quotes: String = ""
    @State private var fallbackAuthorFirstName: String = ""
    @State private var fallbackAuthorLastName: String = ""
    @State private var tags: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("QUOTES")) {
                    VStack(alignment: .leading, spacing: 5) {
                        InstructionsText(
                            text: (
                                "Enter or paste a list of quotes below, with one quote " +
                                "per line and authors attributed after em dashes."
                            )
                        )
                        Spacer()
                        ExampleText(text: "Example:")
                        ExampleText(
                            text: (
                                "This is a good quote. —Author Name\n" +
                                "This is another good one. —Author Name\n" +
                                "And this one is anonymous.\n" +
                                "..."
                            ),
                            italic: true
                        )
                    }.padding([.top, .bottom], 10)
                    TextEditor(text: $quotes)
                }
                Section(header: Text("FALLBACK AUTHOR (optional)")) {
                    VStack(alignment: .leading) {
                        InstructionsText(
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
                        InstructionsText(
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
                        action: { },
                        label: { Text("Save").font(.headline) }
                    ).foregroundColor(.accentColor)
                }
            }
            .navigationTitle("Bulk Add Quotes")
        }
    }
}

struct BulkAddQuotesView_Previews: PreviewProvider {
    static var previews: some View {
        BulkAddQuotesView()
    }
}
