import SwiftUI

/**
 * For adding and editing individual quotes.
 */
struct SingleAddQuoteFormView: View {
    @Environment(\.managedObjectContext) private var context

    var quoteCollection: QuoteCollection
    var quote: Quote?

    var body: some View {
        _SingleAddQuoteFormView(
            quoteCollection: quoteCollection,
            quote: quote,
            collectionOptions:
                quote != nil
                    ? DatabaseFunctions.fetchQuoteCollections(context: context)
                    : nil
        )
    }
}

struct _SingleAddQuoteFormView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    var quoteCollection: QuoteCollection
    var quote: Quote?
    var collectionOptions: [QuoteCollection]?

    @State private var collection: QuoteCollection
    @State private var text: String
    @State private var authorFirstName: String
    @State private var authorLastName: String
    @State private var work: String
    @State private var tags: String
    @State private var isError: Bool
    @State private var errorMessage: String?

    init(
        quoteCollection: QuoteCollection,
        quote: Quote? = nil,
        collectionOptions: [QuoteCollection]?
    ) {
        self.quoteCollection = quoteCollection
        self.quote = quote
        self.collectionOptions = collectionOptions
        if quote != nil {
            _text = State<String>(initialValue: quote!.text!)
            _authorFirstName = State<String>(initialValue: quote!.authorFirstName!)
            _authorLastName = State<String>(initialValue: quote!.authorLastName!)
            _work = State<String>(initialValue: quote!.work!)
            _tags = State<String>(initialValue: quote!.tags!)
        } else {
            _text = State<String>(initialValue: "")
            _authorFirstName = State<String>(initialValue: "")
            _authorLastName = State<String>(initialValue: "")
            _work = State<String>(initialValue: "")
            _tags = State<String>(initialValue: "")
        }
        _collection = State<QuoteCollection>(initialValue: quoteCollection)
        _isError = State<Bool>(initialValue: false)
        _errorMessage = State<String?>(initialValue: nil)
    }

    var body: some View {
        NavigationView {
            Form {
                if collectionOptions != nil && !collectionOptions!.isEmpty {
                    Section(header: Text("COLLECTION")) {
                        Picker("Pick a quote collection...", selection: $collection) {
                            ForEach(collectionOptions!) { option in
                                Text(option.name!).tag(option as QuoteCollection)
                            }
                        }
                    }
                }
                Section(header: Text("TEXT")) {
                    TextEditor(text: $text)
                }
                Section(header: Text("AUTHOR (optional)")) {
                    TextField("First Name", text: $authorFirstName).lineLimit(1)
                    TextField("Last Name", text: $authorLastName).lineLimit(1)
                }
                Section(header: Text("WORK (optional)")) {
                    TextField("Work", text: $work).lineLimit(1)
                }
                Section(header: Text("TAGS (optional)")) {
                    TextField("Tags (comma-separated)", text: $tags).lineLimit(1)
                }
                Section {
                    Button(
                        action: {
                            let values: QuoteValues = QuoteValues(
                                collection: collection,
                                text: text,
                                authorFirstName: authorFirstName,
                                authorLastName: authorLastName,
                                work: work,
                                tags: tags
                            )
                            if quote != nil {
                                values.displayQuotationMarks = quote!.displayQuotationMarks
                                values.displayAuthor = quote!.displayAuthor
                                values.displayWork = quote!.displayWork
                                values.displayAuthorAndWorkOnNewLine = quote!.displayAuthorAndWorkOnNewLine
                            }
                            do {
                                try _ = DatabaseFunctions.addQuote(
                                    context: context,
                                    quote: quote,
                                    values: values
                                )
                                dismiss()
                            } catch ValidationError.withMessage(let message) {
                                isError = true
                                errorMessage = message
                            } catch {
                                isError = true
                                errorMessage = ErrorMessage.default
                            }
                        },
                        label: { SubmitButtonTextView() }
                    )
                }
            }
            .navigationTitle(quote == nil ? "Add Quote" : "Edit Quote")
            .toolbar(
                content: {
                    ToolbarItem(placement: .cancellationAction) {
                        CancelButtonView(dismiss: dismiss)
                    }
                }
            )
            .alert(isPresented: $isError) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage!),
                    dismissButton: .default(
                        Text("Dismiss"),
                        action: {
                            isError = false
                            errorMessage = nil
                        }
                    )
                )
            }
        }
    }
}
