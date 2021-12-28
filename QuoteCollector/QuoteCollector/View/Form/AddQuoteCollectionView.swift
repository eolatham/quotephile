import SwiftUI

/**
 * For adding and editing quote collections.
 */
struct AddQuoteCollectionView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation

    var quoteCollection: QuoteCollection?

    @State private var name: String = ""
    @State private var isError: Bool = false
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("NAME")) {
                    VStack {
                        TextField("", text: $name).lineLimit(1)
                    }
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
                                presentation.wrappedValue.dismiss()
                            } catch ValidationError.withMessage(let message) {
                                isError = true
                                errorMessage = message
                            } catch {
                                isError = true
                                errorMessage = ErrorMessage.default
                            }
                        },
                        label: { Text("Save").font(.headline) }
                    )
                    .foregroundColor(.accentColor)
                }
            }
            .navigationTitle(
                quoteCollection == nil ? "Add Quote Collection" : "Edit Quote Collection"
            )
            .toolbar(
                content: {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { presentation.wrappedValue.dismiss() }
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
        .onAppear {
            if quoteCollection != nil {
                name = quoteCollection!.name!
            }
        }
    }
}
