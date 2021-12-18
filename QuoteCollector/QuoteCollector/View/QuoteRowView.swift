//
//  QuoteRowView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/12/21.
//

import SwiftUI

struct QuoteRowView: View {
    @ObservedObject var quote: Quote
    var body: some View {
        if quote.exists {
            VStack {
                Text(quote.text!)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .font(.body)
                    .lineLimit(2)
                    .truncationMode(.tail)
                if quote.author.count > 0 {
                    Text(quote.author)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .font(.caption)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
        }
        else { EmptyView() }
    }
}
