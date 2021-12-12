//
//  AddQuoteView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/12/21.
//

import SwiftUI
import CoreData

/**
 * For adding and editing quotes.
 */
struct AddQuoteView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentation

    @State private var text: String = ""
    @State private var author: String = ""
    @State private var isError: Bool = false
    @State private var textErrorMsg: String? = nil
    @State private var authorErrorMsg: String? = nil
    
    var quoteCollection: QuoteCollection
    var objectId: NSManagedObjectID?
    
    let viewModel = AddQuoteViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("TEXT")) {
                        TextEditor(text: $text)
                    }
                    Section(header: Text("AUTHOR")) {
                        TextField("Author", text: $author).lineLimit(1)
                    }
                    Section {
                        Button(
                            action: {
                                if text.count < 1 { textErrorMsg = "Text is empty!" }
                                else if text.count > 10000 { textErrorMsg = "Text is too long!" }
                                else { textErrorMsg = nil }
                                
                                if author.count > 1000 { authorErrorMsg = "Author is too long!" }
                                else { authorErrorMsg = nil }
                                
                                isError = textErrorMsg != nil || authorErrorMsg != nil
                            
                                if isError == false {
                                    _ = viewModel.addQuote(
                                        context: context,
                                        objectId: objectId,
                                        values: QuoteValues(
                                            collection: quoteCollection,
                                            text: text,
                                            author: author
                                        )
                                    )
                                    presentation.wrappedValue.dismiss()
                                }
                            },
                            label: { Text("Save").font(.headline) }
                        )
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(.accentColor)
                    }
                }
                .navigationTitle(objectId == nil ? "Add Quote" : "Edit Quote")
                .alert(isPresented: $isError) {
                    Alert(
                        title: Text("Error"),
                        message: Text(textErrorMsg != nil ? textErrorMsg! : authorErrorMsg!),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .onAppear {
                if let quoteId = objectId,
                   let quote = viewModel.fetchQuote(context: context, objectId: quoteId)
                {
                    text = quote.text!
                    author = quote.author!
                }
            }
        }
    }
}
