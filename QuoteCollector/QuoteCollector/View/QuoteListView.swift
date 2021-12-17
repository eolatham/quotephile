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
    
    @ObservedObject var quoteCollection: QuoteCollection
    
    @State private var selectedSort = QuoteSort.default
    @State private var toDelete: [Quote] = []
    @State private var showDeleteAlert: Bool = false
    @State private var showAddQuoteView = false
    @State private var showEditCollectionView = false
    @State private var searchTerm = ""

    @SectionedFetchRequest private var quotes: SectionedFetchResults<String, Quote>
    
    init(quoteCollection: QuoteCollection) {
        self.quoteCollection = quoteCollection
        _quotes = SectionedFetchRequest<String, Quote>(
            sectionIdentifier: QuoteSort.default.section,
            sortDescriptors: QuoteSort.default.descriptors,
            predicate: NSPredicate(format: "collection = %@", quoteCollection),
            animation: .default
        )
    }
    
    var searchQuery: Binding<String> {
        Binding {
            searchTerm
        } set: { newValue in
            searchTerm = newValue
            if newValue.isEmpty {
                quotes.nsPredicate = NSPredicate(format: "collection = %@", quoteCollection)
            } else {
                quotes.nsPredicate = NSCompoundPredicate(
                    andPredicateWithSubpredicates: [
                        NSPredicate(format: "collection = %@", quoteCollection),
                        NSCompoundPredicate(
                            orPredicateWithSubpredicates: [
                                NSPredicate(format: "text CONTAINS[cd] %@", newValue),
                                NSPredicate(format: "authorFirstName CONTAINS[cd] %@", newValue),
                                NSPredicate(format: "authorLastName CONTAINS[cd] %@", newValue)
                            ]
                        )
                    ]
                )
            }
        }
    }

    var body: some View {
        if quoteCollection.exists {
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
                    Button {
                        showAddQuoteView = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    Button {
                        showEditCollectionView = true
                    } label: {
                        Image(systemName: "pencil.circle")
                    }
                }
            }
            .sheet(isPresented: $showAddQuoteView) {
                AddQuoteView(quoteCollection: quoteCollection)
            }
            .sheet(isPresented: $showEditCollectionView) {
                AddQuoteCollectionView(objectId: quoteCollection.objectID)
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
            .navigationTitle(quoteCollection.name!)
        }
        else { EmptyView() }
    }
}
