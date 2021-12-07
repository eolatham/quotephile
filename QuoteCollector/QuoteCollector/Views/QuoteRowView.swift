//
//  QuoteRowView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/6/21.
//

import SwiftUI

struct QuoteRowView: View {
    var quote: Quote
    var body: some View {
        HStack {
            Text(quote.text)
                .font(.body)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

struct QuoteRowView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteRowView(quote: QUOTE_COLLECTIONS[0].quotes[0])
    }
}
