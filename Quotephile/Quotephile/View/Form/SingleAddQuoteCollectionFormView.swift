import SwiftUI

/**
 * For adding and editing individual quote collections.
 */
struct SingleAddQuoteCollectionFormView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    var quoteCollection: QuoteCollection?

    @State private var name: String
    @State private var isError: Bool
    @State private var errorMessage: String?

    init(quoteCollection: QuoteCollection? = nil) {
        self.quoteCollection = quoteCollection
        if quoteCollection != nil {
            _name = State<String>(initialValue: quoteCollection!.name!)
        } else {
            _name = State<String>(initialValue: "")
        }
        _isError = State<Bool>(initialValue: false)
        _errorMessage = State<String?>(initialValue: nil)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("NAME")) {
                    TextField("Name", text: $name).lineLimit(1)
                }
                Section {
                    Button(
                        action: {
                            do {
                                try _ = DatabaseFunctions.addQuoteCollection(
                                    context: context,
                                    quoteCollection: quoteCollection,
                                    values: QuoteCollectionValues(name: name)
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
            .navigationTitle(
                quoteCollection == nil ? "Add Quote Collection" : "Edit Quote Collection"
            )
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
