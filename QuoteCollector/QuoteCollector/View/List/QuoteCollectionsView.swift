import SwiftUI

struct QuoteCollectionsView: View {
    var body: some View {
        _QuoteCollectionsView(
            selectedSort: QuoteCollectionSort.getUserDefault()
        )
        // This wrapping is necessary because initializing state (selectedSort in this case)
        // with an inline function call produces unreliable results; function calls in such
        // contexts seem to be memoized to avoid recomputing them when the view is recreated.
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
                AddQuoteCollectionView,
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
                    NavigationLink {
                        AllQuotesView()
                    } label: {
                        Text("All Quotes").font(.headline)
                    }
                },
                addEntitySheetContentViewBuilder: {
                    AddQuoteCollectionView()
                },
                bulkDeleteFunction: { quoteCollections in
                    DatabaseFunctions.deleteQuoteCollections(
                        context: context,
                        quoteCollections: quoteCollections
                    )
                },
                bulkDeleteAlertMessage: { selected in
                    return (
                        "Deleting the \(selected.count) selected quote " +
                        "collections will also delete all of their " +
                        "quotes. This action cannot be undone!"
                    )
                }
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
