//
//  QuoteCollectionListView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import SwiftUI
import CoreData

struct QuoteCollectionListView: View {
    @Environment(\.managedObjectContext) private var context

    @State private var showAddView = false
    @State private var selectedSort = QuoteCollectionSort.default
    @State private var searchTerm = ""
    
    let viewModel = QuoteCollectionListViewModel()

    @SectionedFetchRequest(
        sectionIdentifier: QuoteCollectionSort.default.section,
        sortDescriptors: QuoteCollectionSort.default.descriptors,
        animation: .default
    )
    private var quoteCollections: SectionedFetchResults<String, QuoteCollection>
    
    var searchQuery: Binding<String> {
        Binding {
            searchTerm
        } set: { newValue in
            searchTerm = newValue
            if newValue.isEmpty {
                quoteCollections.nsPredicate = nil
            } else {
                quoteCollections.nsPredicate = NSPredicate(format: "name CONTAINS[c] %@", newValue)
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(quoteCollections) { section in
                    Section(header: Text(section.id)) {
                        ForEach(section) { quoteCollection in
                            NavigationLink {
                                AddQuoteCollectionView(objectId: quoteCollection.objectID)
                            } label: {
                                QuoteCollectionRowView(quoteCollection: quoteCollection)
                            }
                        }
                        .onDelete { indexSet in
                            withAnimation {
                                viewModel.deleteQuoteCollection(
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
                    SortQuoteCollectionsView(
                        selectedSort: $selectedSort,
                        sorts: QuoteCollectionSort.sorts
                    )
                        .onChange(of: selectedSort) { _ in
                            quoteCollections.sortDescriptors = selectedSort.descriptors
                            quoteCollections.sectionIdentifier = selectedSort.section
                        }
                    Button {
                        showAddView = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .sheet(isPresented: $showAddView) {
                AddQuoteCollectionView()
            }
            .navigationTitle("Quote Collections")
        }
    }
}

struct QuoteCollectionListView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteCollectionListView()
    }
}
