import SwiftUI

/**
 * This wrapping is necessary because initializing state (selectedSort in this case)
 * with an inline function call produces unreliable results; function calls in such
 * contexts seem to be memoized to avoid recomputing them when the view is recreated.
 */
struct AllQuotesView: View {
    var body: some View {
        _AllQuotesView(selectedSort: QuoteSort.getUserDefault())
    }
}

struct _AllQuotesView: View {
    @Environment(\.managedObjectContext) private var context

    @State var selectedSort: Sort<Quote>

    @State private var searchTerm: String = ""

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
            title: "All Quotes",
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
            bulkEditSheetContentViewBuilder: { selection, exitSelectionMode in
                BulkEditQuotesView(quotes: selection)
            },
            bulkMoveSheetContentViewBuilder: { selection, exitSelectionMode in
                BulkMoveQuotesView(quotes: selection)
            },
            bulkDeleteFunction: { selection in
                DatabaseFunctions.deleteQuotes(
                    context: context,
                    quotes: selection
                )
            },
            bulkDeleteAlertMessage: { selection in
                return (
                    "Are you sure you want to delete the \(selection.count) " +
                    "selected quotes? This action cannot be undone!"
                )
            }
        )
        .onChange(
            of: selectedSort,
            perform: { _ in
                QuoteSort.setUserDefault(sort: selectedSort)
            }
        )
    }
}
