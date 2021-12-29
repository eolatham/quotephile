import SwiftUI

struct BulkMoveQuotesView: View {
    @Environment(\.managedObjectContext) private var context

    var quotes: Set<Quote>

    var body: some View {
        _BulkMoveQuotesView(
            quotes: quotes,
            collectionOptions: DatabaseFunctions.fetchQuoteCollections(context: context)
        )
    }
}

struct _BulkMoveQuotesView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation

    var quotes: Set<Quote>
    var collectionOptions: [QuoteCollection]

    @State private var selectedCollection: QuoteCollection

    init(quotes: Set<Quote>, collectionOptions: [QuoteCollection]) {
        self.quotes = quotes
        self.collectionOptions = collectionOptions
        _selectedCollection = State<QuoteCollection>(initialValue: collectionOptions.first!)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("DESTINATION")) {
                    Picker("Quote Collection", selection: $selectedCollection) {
                        ForEach(collectionOptions) { collection in
                            Text(collection.name!).tag(collection)
                        }
                    }
                }
                Section {
                    Button(
                        action: {
                            DatabaseFunctions.moveQuotes(
                                context: context,
                                quotes: quotes,
                                newCollection: selectedCollection
                            )
                            presentation.wrappedValue.dismiss()
                        },
                        label: {
                            Text(
                                "Move \(quotes.count) selected " +
                                "\(quotes.count == 1 ? "quote" : "quotes")"
                            ).font(.headline)
                        }
                    )
                    .foregroundColor(.accentColor)
                }
            }
            .navigationTitle("Move Quotes")
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
