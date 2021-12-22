//
//  QuoteListView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/12/21.
//

import SwiftUI

struct QuoteListView: View {
    @Environment(\.managedObjectContext) private var context
    
    let viewModel = QuoteListViewModel()
    
    var quoteCollection: QuoteCollection? = nil
    
    @State private var selectedSort = QuoteSort.default
    @State private var toDelete: [Quote] = []
    @State private var showDeleteAlert: Bool = false
    @State private var showAddQuoteView: Bool = false
    @State private var showEditCollectionView: Bool = false
    @State private var searchTerm: String = ""

    @SectionedFetchRequest private var quotes: SectionedFetchResults<String, Quote>
    
    init(quoteCollection: QuoteCollection? = nil) {
        self.quoteCollection = quoteCollection
        if quoteCollection == nil {
            // Render all quotes
            _quotes = SectionedFetchRequest<String, Quote>(
                sectionIdentifier: QuoteSort.default.section,
                sortDescriptors: QuoteSort.default.descriptors,
                animation: .default
            )
        } else {
            // Render quotes in the given collection only
            _quotes = SectionedFetchRequest<String, Quote>(
                sectionIdentifier: QuoteSort.default.section,
                sortDescriptors: QuoteSort.default.descriptors,
                predicate: NSPredicate(format: "collection = %@", quoteCollection!),
                animation: .default
            )
        }
    }
    
    /**
     * Only works after initialization!
     */
    func setPredicate() {
        let collectionPredicate: NSPredicate? =
            quoteCollection == nil ? nil
            : NSPredicate(format: "collection = %@", quoteCollection!)
        let searchPredicate: NSPredicate? =
            searchTerm.isEmpty ? nil
            : NSCompoundPredicate(
                orPredicateWithSubpredicates: [
                    NSPredicate(format: "text CONTAINS[cd] %@", searchTerm),
                    NSPredicate(format: "authorFirstName CONTAINS[cd] %@", searchTerm),
                    NSPredicate(format: "authorLastName CONTAINS[cd] %@", searchTerm),
                    NSPredicate(format: "tags CONTAINS[cd] %@", searchTerm)
                ]
            )
        if collectionPredicate == nil && searchPredicate == nil {
            quotes.nsPredicate = nil
        }
        else if collectionPredicate != nil && searchPredicate == nil {
            quotes.nsPredicate = collectionPredicate
        }
        else if collectionPredicate == nil && searchPredicate != nil {
            quotes.nsPredicate = searchPredicate
        }
        else {
            quotes.nsPredicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [
                    collectionPredicate!,
                    searchPredicate!
                ]
            )
        }
    }

    var searchQuery: Binding<String> {
        Binding {
            searchTerm
        } set: { newValue in
            searchTerm = newValue
            setPredicate()
        }
    }

    var body: some View {
        List {
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
                        self.toDelete = indexSet.map { section[$0] }
                        self.showDeleteAlert = true
                    }
                }
            }
        }
        .searchable(text: searchQuery)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                SortQuotesView(
                    selectedSort: $selectedSort,
                    sorts: QuoteSort.sorts
                )
                    .onChange(of: selectedSort) { _ in
                        quotes.sortDescriptors = selectedSort.descriptors
                        quotes.sectionIdentifier = selectedSort.section
                    }
                if quoteCollection != nil {
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
        }
        .sheet(isPresented: $showAddQuoteView) {
            // Only invoked when quoteCollection != nil
            AddQuoteView(quoteCollection: quoteCollection!)
        }
        .sheet(isPresented: $showEditCollectionView) {
            // Only invoked when quoteCollection != nil
            AddQuoteCollectionView(objectId: quoteCollection!.objectID)
        }
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
                        self.toDelete = []
                    }
                },
                secondaryButton: .cancel(Text("No, cancel")) {
                    self.toDelete = []
                }
            )
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(
            quoteCollection == nil ? "All Quotes" : quoteCollection!.name!
        )
    }
}
