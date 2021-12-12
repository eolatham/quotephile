//
//  QuoteRowView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/12/21.
//

import SwiftUI

struct QuoteRowView: View {
    var quote: Quote
    var body: some View {
        Text(quote.text!)
            .font(.headline)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}
