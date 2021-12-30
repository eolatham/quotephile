import SwiftUI

struct EditQuoteView: View {
    var quote: Quote

    var body: some View {
        AddQuoteView(quoteCollection: quote.collection!, quote: quote)
    }
}
