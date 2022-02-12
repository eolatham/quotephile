import SwiftUI

struct QuoteCollectionRowView: View {
    @Environment(\.managedObjectContext) private var context

    @ObservedObject var quoteCollection: QuoteCollection

    var body: some View {
        if quoteCollection.exists {
            _QuoteCollectionRowView(
                name: quoteCollection.name!,
                size: DatabaseFunctions.fetchQuoteCollectionSize(
                    context: context,
                    quoteCollection: quoteCollection
                )
            )
        }
        else { EmptyView() }
    }
}

struct _QuoteCollectionRowView: View {
    var name: String
    var size: Int

    var body: some View {
        HStack {
            Text(name)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer()
            Text(String(size)).font(.caption)
        }
    }
}
