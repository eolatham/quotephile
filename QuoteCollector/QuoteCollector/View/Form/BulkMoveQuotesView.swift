import SwiftUI

struct BulkMoveQuotesView: View {
    @Environment(\.managedObjectContext) private var context

    var quotes: Set<Quote>
    var afterMove: (() -> Void)? = nil

    var body: some View {
        _BulkMoveQuotesView(
            quotes: quotes,
            collectionOptions: DatabaseFunctions.fetchQuoteCollections(context: context),
            afterMove: afterMove
        )
    }
}

struct _BulkMoveQuotesView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation

    var quotes: Set<Quote>
    var collectionOptions: [QuoteCollection]
    var afterMove: (() -> Void)?

    @State private var selectedCollection: QuoteCollection

    init(
        quotes: Set<Quote>,
        collectionOptions: [QuoteCollection],
        afterMove: (() -> Void)? = nil
    ) {
        self.quotes = quotes
        self.collectionOptions = collectionOptions
        self.afterMove = afterMove
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
                            if afterMove != nil { afterMove!() }
                            presentation.wrappedValue.dismiss()
                        },
                        label: { Text("Save").font(.headline) }
                    )
                    .foregroundColor(.accentColor)
                }
            }
            .navigationTitle(quotes.count == 1 ? "Move Quote" : "Move \(quotes.count) Quotes")
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
