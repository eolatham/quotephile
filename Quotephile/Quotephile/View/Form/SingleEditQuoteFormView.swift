import SwiftUI

struct SingleEditQuoteFormView: View {
    var quote: Quote

    var body: some View {
        SingleAddQuoteFormView(quoteCollection: quote.collection!, quote: quote)
    }
}
