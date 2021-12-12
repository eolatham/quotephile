//
//  QuoteListView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/12/21.
//

import SwiftUI

struct QuoteListView: View {
    @Environment(\.managedObjectContext) private var context
    
    @State private var selectedSort = QuoteSort.default
    @State private var showAddQuoteView = false
    @State private var showEditCollectionView = false
    @State private var searchTerm = ""
    
    var quoteCollection: QuoteCollection
    
    let viewModel = QuoteListViewModel()

    @SectionedFetchRequest(
        sectionIdentifier: QuoteSort.default.section,
        sortDescriptors: QuoteSort.default.descriptors,
        animation: .default
    )
    private var quotes: SectionedFetchResults<String, Quote>
    
    var searchQuery: Binding<String> {
        Binding {
            searchTerm
        } set: { newValue in
            searchTerm = newValue
            if newValue.isEmpty {
                quotes.nsPredicate = nil
            } else {
                quotes.nsPredicate = NSPredicate(format: "name CONTAINS[cd] %@", newValue)
            }
        }
    }

    var body: some View {
        VStack {
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
                            withAnimation {
                                viewModel.deleteQuote(
                                    context: context,
                                    section: section,
                                    indexSet: indexSet
                                )
                            }
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
            .navigationTitle(quoteCollection.name!)
        }
    }
}
