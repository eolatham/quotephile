//
//  QuoteView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/12/21.
//

import SwiftUI

struct QuoteView: View {
    var quote: Quote
    var body: some View {
        VStack {
            Text(quote.text!).font(.title)
            Text(quote.author!).font(.headline)
        }
    }
}
