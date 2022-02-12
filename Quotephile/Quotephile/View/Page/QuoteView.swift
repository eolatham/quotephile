import SwiftUI

struct QuoteView: View {
    @Environment(\.managedObjectContext) private var context

    @ObservedObject var quote: Quote

    @State private var displayQuotationMarks: Bool
    @State private var displayAuthor: Bool
    @State private var displayWork: Bool
    @State private var displayAuthorAndWorkOnNewLine: Bool
    @State private var showEditQuoteView: Bool
    @State private var isCopied: Bool

    init(quote: Quote) {
        self.quote = quote
        self.displayQuotationMarks = quote.displayQuotationMarks
        self.displayAuthor = quote.displayAuthor
        self.displayWork = quote.displayWork
        self.displayAuthorAndWorkOnNewLine = quote.displayAuthorAndWorkOnNewLine
        self.showEditQuoteView = false
        self.isCopied = false
    }

    private func displayTextFont() -> Font {
        let length = quote.length
        if length < 100 { return .title2 }
        if length < 200 { return .title3 }
        return .body
    }

    var body: some View {
        Form {
            let displayText: String = quote.displayText
            Section(header: Text("QUOTE")) {
                Text(displayText)
                    .font(displayTextFont())
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true) // Ensure text wraps
                    .padding([.top, .bottom], 6)
                    .padding([.leading, .trailing], 2)
                Button {
                    UIPasteboard.general.string = displayText
                    isCopied = true
                } label: {
                    HStack(alignment: .center, spacing: 2) {
                        Text(isCopied ? "Copied" : "Copy to clipboard")
                        Image(systemName: isCopied ? "checkmark.circle" : "doc.on.doc")
                    }.font(.caption).multilineTextAlignment(.center).frame(maxWidth: .infinity)
                }
            }.id(displayText) // Ensure section refreshes when text changes
            Section(header: Text("STYLE")) {
                Toggle(isOn: $displayQuotationMarks) { Text("Display quotation marks") }
                .tint(.accentColor)
                .onChange(of: displayQuotationMarks) { newValue in
                    quote.displayQuotationMarks = newValue
                    quote.dateChanged = Date.now
                    DatabaseFunctions.commitChanges(context: context)
                }
                Toggle(isOn: $displayAuthor) { Text("Display author") }
                .tint(.accentColor)
                .onChange(of: displayAuthor) { newValue in
                    quote.displayAuthor = newValue
                    quote.dateChanged = Date.now
                    DatabaseFunctions.commitChanges(context: context)
                }
                Toggle(isOn: $displayWork) { Text("Display work") }
                .tint(.accentColor)
                .onChange(of: displayWork) { newValue in
                    quote.displayWork = newValue
                    quote.dateChanged = Date.now
                    DatabaseFunctions.commitChanges(context: context)
                }
                Toggle(isOn: $displayAuthorAndWorkOnNewLine) { Text("Display author and work on new line") }
                .tint(.accentColor)
                .onChange(of: displayAuthorAndWorkOnNewLine) { newValue in
                    quote.displayAuthorAndWorkOnNewLine = newValue
                    quote.dateChanged = Date.now
                    DatabaseFunctions.commitChanges(context: context)
                }
            }
            Section(header: Text("COLLECTION")) {
                Text(quote.collection!.name!).lineLimit(1).padding(.vertical, 10)
            }
            if quote.tags!.count > 0 {
                Section(header: Text("TAGS")) {
                    ScrollView(.horizontal) {
                        Text(quote.tags!).padding(.vertical, 10)
                    }
                }
            }
        }
        .onChange(of: quote.dateChanged!, perform: { _ in isCopied = false })
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button { showEditQuoteView = true } label: { Text("Edit") }
            }
        }
        .sheet(isPresented: $showEditQuoteView) {
            SingleEditQuoteFormView(quote: quote)
        }
    }
}
