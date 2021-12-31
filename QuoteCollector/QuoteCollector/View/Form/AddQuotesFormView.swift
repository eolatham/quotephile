import SwiftUI

struct AddQuotesFormView: View {
    var quoteCollection: QuoteCollection

    var body: some View {
        TabView {
            SingleAddQuoteFormView(quoteCollection: quoteCollection)
                .tabItem { Text("Single").font(.headline) }
            BulkAddQuotesFormView(quoteCollection: quoteCollection)
                .tabItem { Text("Bulk").font(.headline) }
        }
    }
}
