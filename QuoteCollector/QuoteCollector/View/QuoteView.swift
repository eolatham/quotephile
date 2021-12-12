//
//  QuoteView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/12/21.
//

import SwiftUI

struct QuoteView: View {
    var text: String
    var author: String
    var body: some View {
        VStack {
            Text(text).font(.title)
            Text(author).font(.headline)
        }
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView(text: "Quote", author: "Author")
    }
}
