import SwiftUI

struct QuoteCollectionRowView: View {
    @Environment(\.managedObjectContext) private var context

    @ObservedObject var quoteCollection: QuoteCollection
    
    var body: some View {
        if quoteCollection.exists {
            HStack {
                Text(quoteCollection.name!)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
                Text(
                    String(
                        DatabaseFunctions.fetchQuoteCollectionSize(
                            context: context,
                            quoteCollection: quoteCollection
                        )
                    )
                ).font(.caption)
            }
        }
        else { EmptyView() }
    }
}
