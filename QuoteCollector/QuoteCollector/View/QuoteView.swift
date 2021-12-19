//
//  QuoteView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/12/21.
//

import SwiftUI

struct QuoteView: View {

    @ObservedObject var quote: Quote

    @State private var showEditQuoteView = false
    @State private var showCopyQuoteView = false

    var body: some View {
        if quote.exists {
            VStack {
                Text(quote.text!)
                    .font(.title)
                    .multilineTextAlignment(.center)
                Spacer().frame(maxHeight: 25)
                Text(quote.author).font(.body)
            }
            .padding()
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showEditQuoteView = true
                    } label: {
                        Image(systemName: "pencil")
                    }
                    Button {
                        showCopyQuoteView = true
                    } label: {
                        Image(systemName: "doc.on.doc")
                    }
                }
            }
            .sheet(isPresented: $showEditQuoteView) {
                AddQuoteView(
                    quoteCollection: quote.collection!,
                    objectId: quote.objectID
                )
            }
            .sheet(isPresented: $showCopyQuoteView) {
                CopyQuoteView(quote: quote)
            }
        }
        else { EmptyView() }
    }
}
