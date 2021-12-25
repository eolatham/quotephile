//
//  QuoteView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/19/21.
//

import SwiftUI

struct QuoteView: View {
    @Environment(\.managedObjectContext) private var context

    @ObservedObject var quote: Quote

    @State private var displayQuotationMarks: Bool
    @State private var displayAuthor: Bool
    @State private var displayAuthorOnNewLine: Bool
    @State private var showEditQuoteView: Bool

    init(quote: Quote) {
        self.quote = quote
        self.displayQuotationMarks = quote.displayQuotationMarks
        self.displayAuthor = quote.displayAuthor
        self.displayAuthorOnNewLine = quote.displayAuthorOnNewLine
        self.showEditQuoteView = false
    }

    func displayTextFont() -> Font {
        let length = quote.length
        if length < 100 { return .title }
        if length < 200 { return .title2 }
        if length < 300 { return .title3 }
        return .body
    }

    var body: some View {
        Form {
            let displayText: String = quote.displayText
            Section(header: Text("QUOTE")) {
                Text(displayText)
                    .font(displayTextFont())
                    .multilineTextAlignment(.center)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true) // Ensure text wraps
                    .padding()
                Text("Tap and hold quote to copy or share!")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }.id(displayText) // Ensure section refreshes when text changes
            Section(header: Text("STYLE")) {
                Toggle(isOn: $displayQuotationMarks) { Text("Display quotation marks") }
                .onChange(of: displayQuotationMarks) { newValue in
                    quote.displayQuotationMarks = newValue
                    Utility.updateContext(context: context)
                }
                Toggle(isOn: $displayAuthor) { Text("Display author") }
                .onChange(of: displayAuthor) { newValue in
                    quote.displayAuthor = newValue
                    Utility.updateContext(context: context)
                }
                if quote.displayAuthor {
                    Toggle(isOn: $displayAuthorOnNewLine) { Text("Display author on new line") }
                    .onChange(of: displayAuthorOnNewLine) { newValue in
                        quote.displayAuthorOnNewLine = newValue
                        Utility.updateContext(context: context)
                    }
                }
            }
            if quote.tags!.count > 0 {
                Section(header: Text("TAGS")) {
                    ScrollView(.horizontal) {
                        Text(quote.tags!).textSelection(.enabled).padding(.vertical, 10)
                    }
                }
            }
        }
        .navigationTitle("View Quote")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button { showEditQuoteView = true } label: { Text("Edit") }
            }
        }
        .sheet(isPresented: $showEditQuoteView) {
            AddQuoteView(
                quoteCollection: quote.collection!,
                quote: quote
            )
        }
    }
}
