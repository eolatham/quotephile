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
    @State private var nameErrorMsg: String? = nil

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("NAME")) {
                        VStack {
                            TextField("", text: $name).lineLimit(1)
                        }
                    }
                    Section {
                        Button(
                            action: {
                                if name.isEmpty { nameErrorMsg = "Name is empty!" }
                                else { nameErrorMsg = nil }
                                
                                isError = nameErrorMsg != nil
                                
                                if isError == false {
                                    _ = DatabaseFunctions.addQuoteCollection(
                                        context: context,
                                        quoteCollection: quoteCollection,
                                        values: QuoteCollectionValues(name: name)
                                    )
                                    presentation.wrappedValue.dismiss()
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
                        message: Text(nameErrorMsg!),
                        dismissButton: .default(Text("OK"))
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
}
