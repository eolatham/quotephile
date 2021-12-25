//
//  QuoteCollectionListView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import SwiftUI

struct QuoteCollectionListView: View {
    @Environment(\.managedObjectContext) private var context

    let viewModel = QuoteCollectionListViewModel()

    @SectionedFetchRequest var quoteCollections: SectionedFetchResults<String, QuoteCollection>
    var searchQuery: Binding<String>

    @State private var selected: Set<QuoteCollection> = Set<QuoteCollection>()
    @State private var toDelete: [QuoteCollection] = []
    @State private var showDeleteAlert: Bool = false

    var body: some View {
        List(selection: $selected) {
            // All Quotes collection
            NavigationLink {
                AllQuotesView()
            } label: {
                Text("All Quotes").font(.headline)
            }
            // Custom collections
            ForEach(quoteCollections) { section in
                Section(header: Text(section.id)) {
                    ForEach(section) { quoteCollection in
                        NavigationLink {
                            QuoteCollectionView(quoteCollection: quoteCollection)
                        } label: {
                            QuoteCollectionRowView(quoteCollection: quoteCollection)
                        }
                    }
                    .onDelete { indexSet in
                        toDelete = indexSet.map { section[$0] }
                        showDeleteAlert = true
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .toolbar(content: { EditButton() })
        .searchable(text: searchQuery)
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text(
                    "Deleting this quote collection will " +
                    "also delete all of its quotes. " +
                    "This action cannot be undone!"
                ),
                primaryButton: .destructive(Text("Yes, delete")) {
                    withAnimation {
                        viewModel.deleteQuoteCollections(
                            context: context,
                            quoteCollections: toDelete
                        )
                        toDelete = []
                    }
                },
                secondaryButton: .cancel(Text("No, cancel")) {
                    toDelete = []
                }
            )
        }
    }
}

struct QuoteCollectionListContainerView: View {
    @Environment(\.managedObjectContext) private var context

    let viewModel = QuoteCollectionListViewModel()

    @State private var searchTerm: String = ""
    @State private var selectedSort: QuoteCollectionSort = QuoteCollectionSort.default
    @State private var showAddCollectionView: Bool = false

    var searchQuery: Binding<String> {
        Binding { searchTerm } set: { newValue in
            searchTerm = newValue
        }
    }

    var predicate: NSPredicate? {
        searchTerm.isEmpty ? nil : NSPredicate(
            format: "name CONTAINS[cd] %@",
            searchTerm
        )
    }

    var body: some View {
        NavigationView {
            QuoteCollectionListView(
                quoteCollections: SectionedFetchRequest<String, QuoteCollection>(
                    sectionIdentifier: selectedSort.section,
                    sortDescriptors: selectedSort.descriptors,
                    predicate: predicate,
                    animation: .default
                ),
                searchQuery: searchQuery
            )
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    SortQuoteCollectionsView(
                        selectedSort: $selectedSort,
                        sorts: QuoteCollectionSort.sorts
                    )
                    Button {
                        showAddCollectionView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddCollectionView) {
                AddQuoteCollectionView()
            }
            .navigationTitle("Quote Collections")
        }
    }
}
