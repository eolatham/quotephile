//
//  QuoteCollectionRowView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/7/21.
//

import SwiftUI

struct QuoteCollectionRowView: View {
    var name: String
    var body: some View {
        Text(name)
            .font(.headline)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}

struct QuoteCollectionRowView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteCollectionRowView(name: "Quote Collection")
    }
}
