//
//  QuoteCollectionListView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import SwiftUI

struct QuoteCollectionListContainerView: View {
    @Environment(\.managedObjectContext) private var context

    private let viewModel = QuoteCollectionListViewModel()

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
                elements: SectionedFetchRequest<String, QuoteCollection>(
                    sectionIdentifier: selectedSort.section,
                    sortDescriptors: selectedSort.descriptors,
                    predicate: predicate,
                    animation: .default
                ),
                searchQuery: searchQuery,
                selectedSort: $selectedSort,
                sortOptions: QuoteCollectionSort.sorts,
                elementRowViewBuilder: { quoteCollection in
                    QuoteCollectionRowView(quoteCollection: quoteCollection)
                },
                elementContentViewBuilder: { quoteCollection in
                    QuoteCollectionView(quoteCollection: quoteCollection)
                },
                constantListPrefixViewBuilder: {
                    NavigationLink {
                        AllQuotesView()
                    } label: {
                        Text("All Quotes").font(.headline)
                    }
                },
                addElementSheetContentViewBuilder: {
                    AddQuoteCollectionView()
                },
                bulkDeleteFunction: { quoteCollections in
                    viewModel.deleteQuoteCollections(
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
