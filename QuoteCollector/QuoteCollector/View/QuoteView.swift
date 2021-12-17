//
//  QuoteView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/12/21.
//

import SwiftUI

struct QuoteView: View {
    @ObservedObject var quote: Quote
    var body: some View {
        if quote.exists {
            VStack {
                Text(quote.text!)
                    .font(.title)
                    .multilineTextAlignment(.center)
                Text(quote.author)
                    .font(.body)
            }.padding()
        }
        else { EmptyView() }
    }
}
