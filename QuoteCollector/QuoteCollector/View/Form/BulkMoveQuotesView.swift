import SwiftUI

struct BulkMoveQuotesView: View {
    @Environment(\.managedObjectContext) private var context

    var quotes: Set<Quote>
    var customTitle: String? = nil
    var afterMove: (() -> Void)? = nil

    var body: some View {
        _BulkMoveQuotesView(
            quotes: quotes,
            collectionOptions: DatabaseFunctions.fetchQuoteCollections(context: context),
            customTitle: customTitle,
            afterMove: afterMove
        )
    }
}

struct _BulkMoveQuotesView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation

    var quotes: Set<Quote>
    var collectionOptions: [QuoteCollection]
    var customTitle: String?
    var afterMove: (() -> Void)?

    @State private var selectedCollection: QuoteCollection

    init(
        quotes: Set<Quote>,
        collectionOptions: [QuoteCollection],
        customTitle: String? = nil,
        afterMove: (() -> Void)? = nil
    ) {
        self.quotes = quotes
        self.collectionOptions = collectionOptions
        self.customTitle = customTitle
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
            .navigationTitle(
                customTitle != nil
                    ? customTitle!
                    : "Move \(quotes.count) \(quotes.count == 1 ? "Quote" : "Quotes")"
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
