import SwiftUI

struct QuoteCollectionView: View {
    @Environment(\.managedObjectContext) private var context

    @ObservedObject var quoteCollection: QuoteCollection

    @State private var searchTerm: String = ""
    @State private var selectedSort: Sort<Quote> = QuoteSort.default

    private var searchQuery: Binding<String> {
        Binding { searchTerm } set: { newValue in
            searchTerm = newValue
        }
    }

    private var predicate: NSPredicate? {
        let collectionPredicate = NSPredicate(format: "collection = %@", quoteCollection)
        if searchTerm.isEmpty {
            return collectionPredicate
        } else {
            return NSCompoundPredicate(
                andPredicateWithSubpredicates: [
                    collectionPredicate,
                    NSCompoundPredicate(
                        orPredicateWithSubpredicates: [
                            NSPredicate(format: "text CONTAINS[cd] %@", searchTerm),
                            NSPredicate(format: "authorFirstName CONTAINS[cd] %@", searchTerm),
                            NSPredicate(format: "authorLastName CONTAINS[cd] %@", searchTerm),
                            NSPredicate(format: "tags CONTAINS[cd] %@", searchTerm)
                        ]
                    )
                ]
            )
        }
    }

    var body: some View {
        if quoteCollection.exists {
            CustomListView<
                Quote,
                QuoteRowView,
                QuoteView,
                EmptyView,
                EmptyView,
                AddQuoteView,
                EditQuoteCollectionView,
                EmptyView,  // TODO: add bulk edit view
                EmptyView   // TODO: add bulk move view
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
                addEntitySheetContentViewBuilder: {
                    AddQuoteView(quoteCollection: quoteCollection)
                },
                editParentSheetContentViewBuilder: {
                    EditQuoteCollectionView(quoteCollection: quoteCollection)
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
            .navigationTitle(quoteCollection.name!)
        } else { EmptyView() }
    }
}
