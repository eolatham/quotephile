import SwiftUI

struct EditQuoteCollectionView: View {
    var quoteCollection: QuoteCollection

    var body: some View {
        AddQuoteCollectionView(quoteCollection: quoteCollection)
    }
}
