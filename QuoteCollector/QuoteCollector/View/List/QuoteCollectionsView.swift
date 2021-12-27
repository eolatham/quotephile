import SwiftUI

struct QuoteCollectionsView: View {
    @Environment(\.managedObjectContext) private var context

    @State private var searchTerm: String = ""
    @State private var selectedSort: Sort<QuoteCollection> = QuoteCollectionSort.default

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
                bulkDeleteAlertMessage: (
                    "Deleting the selected quote collections " +
                    "will also delete all of their quotes. " +
                    "This action cannot be undone!"
                )
            )
            .navigationTitle("Quote Collections")
        }
    }
}
