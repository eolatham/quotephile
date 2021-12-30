import SwiftUI

struct QuoteCollectionRowView: View {
    @ObservedObject var quoteCollection: QuoteCollection

    var body: some View {
        if quoteCollection.exists {
            Text(quoteCollection.title!)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        else { EmptyView() }
    }
}
