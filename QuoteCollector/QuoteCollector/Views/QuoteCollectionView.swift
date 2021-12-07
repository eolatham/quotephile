//
//  QuoteCollectionView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/6/21.
//

import SwiftUI

struct QuoteCollectionView: View {
    var quoteCollection: QuoteCollection
    var body: some View {
        List(quoteCollection.quotes, id: \.id) { quote in
            NavigationLink {
                QuoteView(quote: quote)
            } label: {
                QuoteRowView(quote: quote)
            }
        }
        .navigationTitle(quoteCollection.name)
    }
}

struct QuoteCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteCollectionView(quoteCollection: quoteCollections[0])
    }
}
