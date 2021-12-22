//
//  QuoteView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/19/21.
//

import SwiftUI

struct QuoteView: View {
    @ObservedObject var quote: Quote

    @State private var showEditQuoteView: Bool
    @State private var includeQuotationMarks: Bool
    @State private var includeAuthor: Bool
    @State private var authorOnSeparateLine: Bool
    @State private var copyText: String

    init(quote: Quote) {
        self.quote = quote
        self.showEditQuoteView = false
        self.includeQuotationMarks = true
        self.includeAuthor = true
        self.authorOnSeparateLine = false
        self.copyText = quote.stringify(
            includeQuotationMarks: true,
            includeAuthor: true,
            authorOnSeparateLine: false
        )
    }

    func refresh() {
        copyText = quote.stringify(
            includeQuotationMarks: includeQuotationMarks,
            includeAuthor: includeAuthor,
            authorOnSeparateLine: authorOnSeparateLine
        )
    }

    func copyTextFont() -> Font {
        if copyText.count < 100 { return .title }
        if copyText.count < 200 { return .title2 }
        if copyText.count < 300 { return .title3 }
        return .body
    }

    var body: some View {
        Form {
            Section(header: Text("QUOTE")) {
                Text(copyText)
                    .font(copyTextFont())
                    .multilineTextAlignment(.center)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity)
                    .padding()
                Text("Tap and hold quote to copy or share!")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            Section(header: Text("STYLE")) {
                Toggle(isOn: $includeQuotationMarks) { Text("Include quotation marks") }
                    .onChange(of: includeQuotationMarks) { newValue in refresh() }
                Toggle(isOn: $includeAuthor) { Text("Include author") }
                    .onChange(of: includeAuthor) { newValue in refresh() }
                if includeAuthor {
                    Toggle(isOn: $authorOnSeparateLine) { Text("Author on separate line") }
                        .onChange(of: authorOnSeparateLine) { newValue in refresh() }
                }
            }
            if quote.tags!.count > 0 {
                Section(header: Text("TAGS")) {
                    ScrollView(.horizontal) {
                        Text(quote.tags!).textSelection(.enabled)
                    }
                }
            }
        }
        .navigationTitle("View Quote")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showEditQuoteView = true
                } label: {
                    Image(systemName: "pencil")
                }
            }
        }
        .sheet(isPresented: $showEditQuoteView) {
            AddQuoteView(
                quoteCollection: quote.collection!,
                objectId: quote.objectID
            ).onDisappear(perform: refresh)
        }
    }
}
