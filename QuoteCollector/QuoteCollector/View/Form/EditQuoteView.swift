import SwiftUI

struct EditQuoteView: View {
    var quoteCollection: QuoteCollection
    var quote: Quote
    
    var body: some View {
        AddQuoteView(quoteCollection: quoteCollection, quote: quote)
    }
}
