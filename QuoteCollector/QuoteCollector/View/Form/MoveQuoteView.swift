import SwiftUI

struct MoveQuoteView: View {
    var quote: Quote

    var body: some View {
        BulkMoveQuotesView(quotes: [quote])
    }
}
