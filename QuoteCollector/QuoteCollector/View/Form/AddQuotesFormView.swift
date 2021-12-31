import SwiftUI

struct AddQuotesFormView: View {
    var quoteCollection: QuoteCollection

    var body: some View {
        TabView {
            SingleAddQuoteFormView(quoteCollection: quoteCollection)
            .tabItem {
                Label("Single", systemImage: "1.circle").font(.title)
            }.labelStyle(.titleAndIcon)
            BulkAddQuotesFormView(quoteCollection: quoteCollection)
            .tabItem {
                Label("Bulk", systemImage: "infinity.circle").font(.title)
            }.labelStyle(.titleAndIcon)
        }
    }
}
