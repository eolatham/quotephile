//
//  QuoteView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/6/21.
//

import SwiftUI

struct QuoteView: View {
    var quote: Quote
    var body: some View {
        VStack {
            Text(quote.text).font(.title)
            // TODO: add share options
        }.padding()
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView(quote: quoteCollections[0].quotes[0])
    }
}
