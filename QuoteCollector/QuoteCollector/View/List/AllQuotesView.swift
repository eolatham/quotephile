import SwiftUI

struct AllQuotesView: View {
    @Environment(\.managedObjectContext) private var context

    @State private var searchTerm: String = ""
    @State private var selectedSort: Sort<Quote> = QuoteSort.default

    private var searchQuery: Binding<String> {
        Binding { searchTerm } set: { newValue in
            searchTerm = newValue
        }
    }

    private var predicate: NSPredicate? {
        searchTerm.isEmpty ? nil : NSCompoundPredicate(
            orPredicateWithSubpredicates: [
                NSPredicate(format: "text CONTAINS[cd] %@", searchTerm),
                NSPredicate(format: "authorFirstName CONTAINS[cd] %@", searchTerm),
                NSPredicate(format: "authorLastName CONTAINS[cd] %@", searchTerm),
                NSPredicate(format: "tags CONTAINS[cd] %@", searchTerm)
            ]
        )
    }

    var body: some View {
        CustomListView<
            Quote,
            QuoteRowView,
            QuoteView,
            EmptyView,
            EmptyView,
            EmptyView,
            EmptyView,
            BulkEditQuotesView,
            BulkMoveQuotesView
        >(
            entities: SectionedFetchRequest<String, Quote>(
                sectionIdentifier: selectedSort.section,
                sortDescriptors: selectedSort.descriptors,
                predicate: predicate,
                animation: .default
            ),
            searchQuery: searchQuery,
            selectedSort: $selectedSort,
            sortOptions: QuoteSort.sorts,
            entityRowViewBuilder: { quote in
                QuoteRowView(quote: quote)
            },
            entityPageViewBuilder: { quote in
                QuoteView(quote: quote)
            },
            bulkEditSheetContentViewBuilder: { quotes in
                BulkEditQuotesView(quotes: quotes)
            },
            bulkMoveSheetContentViewBuilder: { quotes in
                BulkMoveQuotesView(quotes: quotes)
            },
            bulkDeleteFunction: { quotes in
                DatabaseFunctions.deleteQuotes(
                    context: context,
                    quotes: quotes
                )
            },
            bulkDeleteAlertMessage: (
                "Are you sure you want to delete the selected " +
                "quotes? This action cannot be undone!"
            )
        )
        .navigationTitle("All Quotes")
    }
}
