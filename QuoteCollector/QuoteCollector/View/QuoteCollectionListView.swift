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
    
    let viewModel = QuoteCollectionListViewModel()

    @State private var selectedSort = QuoteCollectionSort.default
    @State private var toDelete: [QuoteCollection] = []
    @State private var showDeleteAlert: Bool = false
    @State private var showAddCollectionView = false
    @State private var searchTerm = ""

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
                quoteCollections.nsPredicate = NSPredicate(format: "name CONTAINS[cd] %@", newValue)
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
                                QuoteListView(quoteCollection: quoteCollection)
                            } label: {
                                QuoteCollectionRowView(quoteCollection: quoteCollection)
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
                    SortQuoteCollectionsView(
                        selectedSort: $selectedSort,
                        sorts: QuoteCollectionSort.sorts
                    )
                        .onChange(of: selectedSort) { _ in
                            quoteCollections.sortDescriptors = selectedSort.descriptors
                            quoteCollections.sectionIdentifier = selectedSort.section
                        }
                    Button {
                        showAddCollectionView = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .sheet(isPresented: $showAddCollectionView) {
                AddQuoteCollectionView()
            }
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
                            self.toDelete = []
                        }
                    },
                    secondaryButton: .cancel(Text("No, cancel")) {
                        self.toDelete = []
                    }
                )
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Quote Collections")
        }
    }
}
