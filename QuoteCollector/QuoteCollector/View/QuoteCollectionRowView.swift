//
//  QuoteCollectionRowView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/7/21.
//

import SwiftUI

struct QuoteCollectionRowView: View {
    @ObservedObject var quoteCollection: QuoteCollection
    var body: some View {
        if quoteCollection.exists {
            Text(quoteCollection.name!)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        else { EmptyView() }
    }
}
