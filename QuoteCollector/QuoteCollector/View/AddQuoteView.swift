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

    let viewModel = AddQuoteViewModel()

    var quoteCollection: QuoteCollection
    var quote: Quote?

    @State private var text: String = ""
    @State private var authorFirstName: String = ""
    @State private var authorLastName: String = ""
    @State private var tags: String = ""
    @State private var isError: Bool = false
    @State private var textErrorMsg: String? = nil
    @State private var authorFirstNameErrorMsg: String? = nil
    @State private var authorLastNameErrorMsg: String? = nil
    @State private var tagsErrorMsg: String? = nil

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("TEXT")) {
                        VStack {
                            TextEditor(text: $text)
                        }
                    }
                    Section(header: Text("AUTHOR")) {
                        VStack {
                            TextField("First Name (optional)", text: $authorFirstName)
                                .lineLimit(1)
                            TextField("Last Name (optional)", text: $authorLastName)
                                .lineLimit(1)
                        }
                    }
                    Section(header: Text("TAGS")) {
                        VStack {
                            TextField("Tags (comma-separated)", text: $tags)
                                .lineLimit(1)
                        }
                    }
                    Section {
                        Button(
                            action: {
                                if text.count < 1 { textErrorMsg = "Text is empty!" }
                                else if text.count > 10000 { textErrorMsg = "Text is too long!" }
                                else { textErrorMsg = nil }
                                
                                if authorFirstName.count > 500 {
                                    authorFirstNameErrorMsg = "Author first name is too long!"
                                }
                                else { authorFirstNameErrorMsg = nil }
                                
                                if authorLastName.count > 500 {
                                    authorLastNameErrorMsg = "Author last name is too long!"
                                }
                                else { authorLastNameErrorMsg = nil }
                                
                                if tags.count > 1000 {
                                    tagsErrorMsg = "Tags are too long!"
                                }
                                else { tagsErrorMsg = nil }

                                isError = textErrorMsg != nil ||
                                          authorFirstNameErrorMsg != nil ||
                                          authorLastNameErrorMsg != nil ||
                                          tagsErrorMsg != nil

                                if isError == false {
                                    var values: QuoteValues = QuoteValues(
                                        collection: quoteCollection,
                                        text: text,
                                        authorFirstName: authorFirstName,
                                        authorLastName: authorLastName,
                                        tags: tags
                                    )
                                    if quote != nil {
                                        values.displayQuotationMarks = quote!.displayQuotationMarks
                                        values.displayAuthor = quote!.displayAuthor
                                        values.displayAuthorOnNewLine = quote!.displayAuthorOnNewLine
                                    }
                                    _ = viewModel.addQuote(
                                        context: context,
                                        quote: quote,
                                        values: values
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
                .navigationTitle(quote == nil ? "Add Quote" : "Edit Quote")
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
                        message: Text(
                            Utility.join(
                                strings: [
                                    textErrorMsg,
                                    authorFirstNameErrorMsg,
                                    authorLastNameErrorMsg,
                                    tagsErrorMsg
                                ]
                            )
                        ),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .onAppear {
                if quote != nil {
                    text = quote!.text!
                    authorFirstName = quote!.authorFirstName!
                    authorLastName = quote!.authorLastName!
                    tags = quote!.tags!
                }
            }
        }
    }
}
