import SwiftUI

/**
 * For moving quotes between quote collections.
 */
struct BulkMoveQuotesView: View {
    @Environment(\.managedObjectContext) private var context

    var quotes: Set<Quote>
    var customTitle: String? = nil
    var afterMove: ((_ destination: QuoteCollection) -> Void)? = nil

    var body: some View {
        _BulkMoveQuotesView(
            quotes: quotes,
            destinationOptions: DatabaseFunctions.fetchQuoteCollections(context: context),
            customTitle: customTitle,
            afterMove: afterMove
        )
    }
}

struct _BulkMoveQuotesView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation

    var quotes: Set<Quote>
    var destinationOptions: [QuoteCollection]
    var customTitle: String?
    var afterMove: ((QuoteCollection) -> Void)?

    @State private var selectedDestination: QuoteCollection?

    init(
        quotes: Set<Quote>,
        destinationOptions: [QuoteCollection],
        customTitle: String? = nil,
        afterMove: ((QuoteCollection) -> Void)? = nil
    ) {
        self.quotes = quotes
        self.destinationOptions = destinationOptions
        self.customTitle = customTitle
        self.afterMove = afterMove
        _selectedDestination = State<QuoteCollection?>(initialValue: destinationOptions.first)
    }

    var body: some View {
        NavigationView {
            VStack {
                if destinationOptions.isEmpty {
                    // This never actually happens, but is here just in case
                    Text(
                        "There are no quote collections to move to... " +
                        "Please add one and try again."
                    )
                    .multilineTextAlignment(.leading)
                    .font(.headline)
                    .padding()
                    Spacer()
                } else {
                    // Only renders when !destinationOptions.isEmpty && selectedDestination != nil
                    // (because of initialization logic)
                    Form {
                        Section(header: Text("DESTINATION")) {
                            Picker("Pick a quote collection...", selection: $selectedDestination) {
                                ForEach(destinationOptions) { option in
                                    Text(option.name!).tag(option as QuoteCollection?)
                                }
                            }
                        }
                        Section {
                            Button(
                                action: {
                                    DatabaseFunctions.moveQuotes(
                                        context: context,
                                        quotes: quotes,
                                        newCollection: selectedDestination!
                                    )
                                    if afterMove != nil { afterMove!(selectedDestination!) }
                                    presentation.wrappedValue.dismiss()
                                },
                                label: { Text("Save").font(.headline) }
                            )
                            .foregroundColor(.accentColor)
                        }
                    }
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
