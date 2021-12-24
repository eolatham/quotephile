//
//  QuoteListView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/12/21.
//

import SwiftUI

struct QuoteListView: View {
    @Environment(\.managedObjectContext) private var context

    let viewModel: QuoteListViewModel = QuoteListViewModel()

    @SectionedFetchRequest var quotes: SectionedFetchResults<String, Quote>
    var searchQuery: Binding<String>

    @State private var selectedQuotes: UUID?
    @State private var toDelete: [Quote] = []
    @State private var showDeleteAlert: Bool = false

    var body: some View {
        List(selection: $selectedQuotes) {
            ForEach(quotes) { section in
                Section(header: Text(section.id)) {
                    ForEach(section) { quote in
                        NavigationLink {
                            QuoteView(quote: quote)
                        } label: {
                            QuoteRowView(quote: quote)
                        }
                    }
                    .onDelete { indexSet in
                        toDelete = indexSet.map { section[$0] }
                        showDeleteAlert = true
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())  // Delete this?
        .searchable(text: searchQuery)
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text(
                    "Are you sure you want to delete this quote? " +
                    "This action cannot be undone!"
                ),
                primaryButton: .destructive(Text("Yes, delete")) {
                    withAnimation {
                        viewModel.deleteQuotes(
                            context: context,
                            quotes: toDelete
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

struct AllQuotesView: View {
    @Environment(\.managedObjectContext) private var context

    let viewModel = QuoteListViewModel()

    @State private var searchTerm: String = ""
    @State private var selectedSort: QuoteSort = QuoteSort.default
    @State private var showAddQuoteView: Bool = false
    @State private var showEditCollectionView: Bool = false

    var searchQuery: Binding<String> {
        Binding { searchTerm } set: { newValue in
            searchTerm = newValue
        }
    }

    var predicate: NSPredicate? {
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
        QuoteListView(
            quotes: SectionedFetchRequest<String, Quote>(
                sectionIdentifier: selectedSort.section,
                sortDescriptors: selectedSort.descriptors,
                predicate: predicate,
                animation: .default
            ),
            searchQuery: searchQuery
        )
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                SortQuotesView(
                    selectedSort: $selectedSort,
                    sorts: QuoteSort.sorts
                )
            }
        }
        .navigationTitle("All Quotes")
    }
}

struct QuoteCollectionView: View {
    @Environment(\.managedObjectContext) private var context

    let viewModel = QuoteListViewModel()

    @ObservedObject var quoteCollection: QuoteCollection

    @State private var searchTerm: String = ""
    @State private var selectedSort: QuoteSort = QuoteSort.default
    @State private var showAddQuoteView: Bool = false
    @State private var showEditCollectionView: Bool = false

    var searchQuery: Binding<String> {
        Binding { searchTerm } set: { newValue in
            searchTerm = newValue
        }
    }

    var predicate: NSPredicate? {
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
        QuoteListView(
            quotes: SectionedFetchRequest<String, Quote>(
                sectionIdentifier: selectedSort.section,
                sortDescriptors: selectedSort.descriptors,
                predicate: predicate,
                animation: .default
            ),
            searchQuery: searchQuery
        )
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                SortQuotesView(
                    selectedSort: $selectedSort,
                    sorts: QuoteSort.sorts
                )
                Button {
                    showAddQuoteView = true
                } label: {
                    Image(systemName: "plus")
                }
                Button {
                    showEditCollectionView = true
                } label: {
                    Image(systemName: "pencil")
                }
            }
        }
        .sheet(isPresented: $showAddQuoteView) {
            AddQuoteView(quoteCollection: quoteCollection)
        }
        .sheet(isPresented: $showEditCollectionView) {
            AddQuoteCollectionView(quoteCollection: quoteCollection)
        }
        .navigationTitle(quoteCollection.name!)
    }
}
