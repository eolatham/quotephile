//
//  QuoteRowView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/7/21.
//

import SwiftUI

struct QuoteRowView: View {
    var quote: Quote
    var body: some View {
        Text(quote.text!)
            .font(.body)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}
