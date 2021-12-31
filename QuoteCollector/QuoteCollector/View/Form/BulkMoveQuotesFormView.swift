import SwiftUI

/**
 * For moving quotes between quote collections.
 */
struct BulkMoveQuotesFormView: View {
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
    var customTitle: String? = nil
    var afterMove: ((QuoteCollection) -> Void)? = nil

    @State private var selectedDestination: QuoteCollection? = nil
    @State private var showAlert: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                if destinationOptions.isEmpty {
                    Text(
                        "There are no quote collections to move to... " +
                        "Please add one and try again."
                    )
                    .multilineTextAlignment(.leading)
                    .font(.headline)
                    .padding()
                    Spacer()
                } else {
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
                                    if selectedDestination == nil { showAlert = true }
                                    else {
                                        DatabaseFunctions.bulkMoveQuotes(
                                            context: context,
                                            quotes: quotes,
                                            newCollection: selectedDestination!
                                        )
                                        if afterMove != nil { afterMove!(selectedDestination!) }
                                        presentation.wrappedValue.dismiss()
                                    }
                                },
                                label: { SubmitButtonTextView() }
                            )
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
                        .foregroundColor(.accentColor)
                    }
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("No destination is selected!"),
                    dismissButton: .default(Text("Dismiss"))
                )
            }
        }
    }
}
