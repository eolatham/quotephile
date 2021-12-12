//
//  QuoteRowView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/12/21.
//

import SwiftUI

struct QuoteRowView: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.headline)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}

struct QuoteRowView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteRowView(text: "Quote")
    }
}
