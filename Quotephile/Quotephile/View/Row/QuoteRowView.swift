import SwiftUI

struct QuoteRowView: View {
    @ObservedObject var quote: Quote

    var body: some View {
        if quote.exists {
            VStack(alignment: .leading) {
                Text(quote.rawText)
                    .font(.body)
                    .lineLimit(2)
                    .truncationMode(.tail)
                Text(quote.authorAndWork)
                    .font(.caption)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        else { EmptyView() }
    }
}
