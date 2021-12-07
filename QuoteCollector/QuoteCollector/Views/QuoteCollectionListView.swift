//
//  QuoteCollectionListView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/6/21.
//

import SwiftUI

struct QuoteCollectionListView: View {
    var quoteCollections: [QuoteCollection]
    var body: some View {
        NavigationView {
            List(quoteCollections, id: \.id) { quoteCollection in
                NavigationLink {
                    QuoteCollectionView(quoteCollection: quoteCollection)
                } label: {
                    QuoteCollectionRowView(quoteCollection: quoteCollection)
                }
            }
            .navigationTitle("Quote Collections")
        }
    }
}

struct QuoteCollectionListView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteCollectionListView(quoteCollections: quoteCollections)
    }
}
