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
    @State private var textError: String? = nil
    @State private var authorError: String? = nil
    
    var quoteCollection: QuoteCollection
    var objectId: NSManagedObjectID?
    
    let viewModel = AddQuoteViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    VStack {
                        TextField(
                            "Text",
                            text: $text,
                            prompt: Text("Text")
                        )
                        if textError != nil {
                            Text(textError!).foregroundColor(.red)
                        }
                        TextField(
                            "Author",
                            text: $author,
                            prompt: Text("Author")
                        )
                        if authorError != nil {
                            Text(authorError!).foregroundColor(.red)
                        }
                    }
                    Button {
                        if text.count < 1 { textError = "Text is empty!" }
                        else if text.count > 10000 { textError = "Text is too long!" }
                        else { textError = nil }
                        
                        if author.count > 1000 { authorError = "Author is too long!" }
                        else { authorError = nil }
                        
                        if textError == nil && authorError == nil {
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
                    } label: {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                }
                .navigationTitle(objectId == nil ? "Add Quote" : "Edit Quote")
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
