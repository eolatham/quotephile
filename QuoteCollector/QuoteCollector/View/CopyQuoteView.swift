//
//  CopyQuoteView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/19/21.
//

import SwiftUI

struct CopyQuoteView: View {
    let copyButtonLabelBefore: Text = Text("Copy").foregroundColor(.accentColor)
    let copyButtonLabelAfter: Text = Text("Copied").foregroundColor(.green)

    @ObservedObject var quote: Quote

    @State private var copyText: String
    @State private var includeQuotationMarks: Bool
    @State private var includeAuthor: Bool
    @State private var authorOnSeparateLine: Bool
    @State private var copyButtonLabel: Text

    init(quote: Quote) {
        self.quote = quote
        self.copyText = ""
        self.includeQuotationMarks = true
        self.includeAuthor = true
        self.authorOnSeparateLine = false
        self.copyButtonLabel = copyButtonLabelBefore
        self.copyText = quote.stringify(
            includeQuotationMarks: self.includeQuotationMarks,
            includeAuthor: self.includeAuthor,
            authorOnSeparateLine: self.authorOnSeparateLine
        )
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
        VStack {
            Toggle(isOn: $includeQuotationMarks) { Text("Include quotation marks") }
                .onChange(of: includeQuotationMarks) { newValue in refresh() }
            Toggle(isOn: $includeAuthor) { Text("Include author") }
                .onChange(of: includeAuthor) { newValue in refresh() }
            if includeAuthor {
                Toggle(isOn: $authorOnSeparateLine) { Text("Author on separate line") }
                    .onChange(of: authorOnSeparateLine) { newValue in refresh() }
            }
            Text(copyText)
                .font(.title)
                .multilineTextAlignment(.center)
            Button(
                action: {
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = copyText
                    copyButtonLabel = copyButtonLabelAfter
                },
                label: { copyButtonLabel }
            )
        }
        .padding()
    }
}
