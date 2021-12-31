import SwiftUI

struct SingleMoveQuoteFormView: View {
    var quote: Quote

    var body: some View {
        BulkMoveQuotesFormView(quotes: [quote], customTitle: "Move Quote")
    }
}
