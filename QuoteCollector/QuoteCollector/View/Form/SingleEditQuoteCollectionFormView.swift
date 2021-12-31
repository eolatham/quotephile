import SwiftUI

struct SingleEditQuoteCollectionFormView: View {
    var quoteCollection: QuoteCollection

    var body: some View {
        SingleAddQuoteCollectionFormView(quoteCollection: quoteCollection)
    }
}
