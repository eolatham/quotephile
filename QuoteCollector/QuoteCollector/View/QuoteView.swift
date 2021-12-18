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
                        Image(systemName: "pencil.circle")
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
        else { EmptyView() }
    }
}
