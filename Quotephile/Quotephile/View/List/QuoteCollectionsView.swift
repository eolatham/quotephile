import SwiftUI

/**
 * This wrapping is necessary because initializing state (selectedSort in this case)
 * with an inline function call produces unreliable results; function calls in such
 * contexts seem to be memoized to avoid recomputing them when the view is recreated.
 */
struct QuoteCollectionsView: View {
    var body: some View {
        _QuoteCollectionsView(
            selectedSort: QuoteCollectionSort.getUserDefault()
        )
    }
}

struct _QuoteCollectionsView: View {
    @Environment(\.managedObjectContext) private var context

    @State var selectedSort: Sort<QuoteCollection>

    @State private var searchTerm: String = ""

    private var searchQuery: Binding<String> {
        Binding { searchTerm } set: { newValue in
            searchTerm = newValue
        }
    }

    private var predicate: NSPredicate? {
        searchTerm.isEmpty ? nil : NSPredicate(
            format: "name CONTAINS[cd] %@",
            searchTerm
        )
    }

    var body: some View {
        NavigationView {
            CustomListView<
                QuoteCollection,
                QuoteCollectionRowView,
                QuoteCollectionView,
                NavigationLink,
                EmptyView,
                SingleAddQuoteCollectionFormView,
                SingleEditQuoteCollectionFormView,
                EmptyView,
                EmptyView,
                EmptyView
            >(
                title: "Quote Collections",
                entities: SectionedFetchRequest<String, QuoteCollection>(
                    sectionIdentifier: selectedSort.section,
                    sortDescriptors: selectedSort.descriptors,
                    predicate: predicate,
                    animation: .default
                ),
                searchQuery: searchQuery,
                selectedSort: $selectedSort,
                sortOptions: QuoteCollectionSort.sorts,
                entityRowViewBuilder: { quoteCollection in
                    QuoteCollectionRowView(quoteCollection: quoteCollection)
                },
                entityPageViewBuilder: { quoteCollection in
                    QuoteCollectionView(quoteCollection: quoteCollection)
                },
                constantListPrefixViewBuilder: {
                    NavigationLink { AllQuotesView() }
                    label: { Text("All Quotes").font(.headline) }
                },
                addEntitiesSheetViewBuilder: {
                    SingleAddQuoteCollectionFormView()
                },
                singleEditSheetViewBuilder: { quoteCollection in
                    SingleEditQuoteCollectionFormView(quoteCollection: quoteCollection)
                },
                singleDeleteFunction: { quoteCollection in
                    DatabaseFunctions.deleteQuoteCollection(
                        context: context,
                        quoteCollection: quoteCollection
                    )
                },
                singleDeleteAlertMessage: { _ in
                    "Deleting this quote collection will also delete " +
                    "all of its quotes. This action cannot be undone!"
                },
                bulkDeleteFunction: { quoteCollections in
                    DatabaseFunctions.deleteQuoteCollections(
                        context: context,
                        quoteCollections: quoteCollections
                    )
                },
                bulkDeleteAlertMessage: { _ in
                    "Deleting the selected quote collections will also " +
                    "delete all of their quotes. This action cannot be undone!"
                },
                backupFunction: { DatabaseFunctions.backup(context: context) },
                backupDefaultDocumentName: "Quotephile Backup",
                restoreFunction: { backup in
                    try DatabaseFunctions.restore(context: context, backup: backup)
                },
                restoreAlertMessage: (
                    "Restoring from a backup will delete all quote collections " +
                    "and quotes that are not in the selected backup file. " +
                    "This action cannot be undone!"
                )
            )
            .onChange(
                of: selectedSort,
                perform: { _ in
                    QuoteCollectionSort.setUserDefault(sort: selectedSort)
                }
            )
        }
    }
}
