//
//  QuoteView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/19/21.
//

import SwiftUI

struct QuoteView: View {
    let copyButtonLabelBefore: Text = Text("Copy").foregroundColor(.accentColor)
    let copyButtonLabelAfter: Text = Text("Copied").foregroundColor(.green)

    @ObservedObject var quote: Quote

    @State private var showEditQuoteView: Bool
    @State private var includeQuotationMarks: Bool
    @State private var includeAuthor: Bool
    @State private var authorOnSeparateLine: Bool
    @State private var copyText: String
    @State private var copyButtonLabel: Text

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
        self.copyButtonLabel = copyButtonLabelBefore
    }

    func refresh() {
        copyText = quote.stringify(
            includeQuotationMarks: includeQuotationMarks,
            includeAuthor: includeAuthor,
            authorOnSeparateLine: authorOnSeparateLine
        )
        copyButtonLabel = copyButtonLabelBefore
    }

    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            Text(copyText)
                .font(.title)
                .multilineTextAlignment(.center)
                .frame(maxHeight: .infinity)
                .padding()
            Form {
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
                Section {
                    Button(
                        action: {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = copyText
                            copyButtonLabel = copyButtonLabelAfter
                        },
                        label: {
                            copyButtonLabel.font(.headline)
                        }
                    )
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
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
            )
        }
    }
}
