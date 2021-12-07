//
//  QuoteCollectionRowView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/6/21.
//

import SwiftUI

struct QuoteCollectionRowView: View {
    var quoteCollection: QuoteCollection
    var body: some View {
        HStack {
            Text(quoteCollection.name)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

struct QuoteCollectionRowView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteCollectionRowView(quoteCollection: quoteCollections[0])
    }
}
