//
//  QuoteListView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/12/21.
//

import SwiftUI

struct AllQuotesView: View {
    @Environment(\.managedObjectContext) private var context

    private let viewModel = QuoteListViewModel()

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
        GroupedMultiSelectNavigationListView<
            Quote,
            QuoteRowView,
            QuoteView,
            EmptyView,
            EmptyView,
            EmptyView,
            EmptyView,
            EmptyView,  // TODO: add bulk edit view
            EmptyView   // TODO: add bulk move view
        >(
            elements: SectionedFetchRequest<String, Quote>(
                sectionIdentifier: selectedSort.section,
                sortDescriptors: selectedSort.descriptors,
                predicate: predicate,
                animation: .default
            ),
            searchQuery: searchQuery,
            selectedSort: $selectedSort,
            sortOptions: QuoteSort.sorts,
            elementRowViewBuilder: { quote in
                QuoteRowView(quote: quote)
            },
            elementContentViewBuilder: { quote in
                QuoteView(quote: quote)
            },
            bulkDeleteFunction: { quotes in
                viewModel.deleteQuotes(
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

struct QuoteCollectionView: View {
    @Environment(\.managedObjectContext) private var context

    private let viewModel = QuoteListViewModel()

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
            GroupedMultiSelectNavigationListView<
                Quote,
                QuoteRowView,
                QuoteView,
                EmptyView,
                EmptyView,
                AddQuoteView,
                AddQuoteCollectionView,
                EmptyView,  // TODO: add bulk edit view
                EmptyView   // TODO: add bulk move view
            >(
                elements: SectionedFetchRequest<String, Quote>(
                    sectionIdentifier: selectedSort.section,
                    sortDescriptors: selectedSort.descriptors,
                    predicate: predicate,
                    animation: .default
                ),
                searchQuery: searchQuery,
                selectedSort: $selectedSort,
                sortOptions: QuoteSort.sorts,
                elementRowViewBuilder: { quote in
                    QuoteRowView(quote: quote)
                },
                elementContentViewBuilder: { quote in
                    QuoteView(quote: quote)
                },
                addElementSheetContentViewBuilder: {
                    AddQuoteView(quoteCollection: quoteCollection)
                },
                editParentSheetContentViewBuilder: {
                    AddQuoteCollectionView(quoteCollection: quoteCollection)
                },
                bulkDeleteFunction: { quotes in
                    viewModel.deleteQuotes(
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
