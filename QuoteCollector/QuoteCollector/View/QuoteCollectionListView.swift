//
//  QuoteCollectionListView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import SwiftUI

struct QuoteCollectionListItemView: View {
    @ObservedObject var quoteCollection: QuoteCollection
    var inSelectionMode: Bool
    var selectedQuoteCollections: Binding<Set<QuoteCollection>>

    var body: some View {
        let isSelected: Bool = selectedQuoteCollections.wrappedValue.contains(quoteCollection)
        if inSelectionMode {
            HStack {
                Button {
                    if isSelected {
                        selectedQuoteCollections.wrappedValue.remove(quoteCollection)
                    } else {
                        selectedQuoteCollections.wrappedValue.update(with: quoteCollection)
                    }
                } label: {
                    Image(
                        systemName: isSelected
                            ? "checkmark.circle.fill"
                            : "checkmark.circle"
                    )
                }
                QuoteCollectionRowView(quoteCollection: quoteCollection)
            }.foregroundColor(isSelected ? .accentColor : .black)
        } else {
            NavigationLink {
                QuoteCollectionView(quoteCollection: quoteCollection)
            } label: {
                QuoteCollectionRowView(quoteCollection: quoteCollection)
            }
        }
    }
}

struct QuoteCollectionListView: View {
    @Environment(\.managedObjectContext) private var context

    let viewModel = QuoteCollectionListViewModel()

    @SectionedFetchRequest var quoteCollections: SectionedFetchResults<String, QuoteCollection>
    var searchQuery: Binding<String>
    var inSelectionMode: Binding<Bool>
    var selectedQuoteCollections: Binding<Set<QuoteCollection>>

    @State private var showDeleteAlert: Bool = false

    var body: some View {
        List {
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
                        QuoteCollectionListItemView(
                            quoteCollection: quoteCollection,
                            inSelectionMode: inSelectionMode.wrappedValue,
                            selectedQuoteCollections: selectedQuoteCollections
                        )
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: searchQuery)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    if inSelectionMode.wrappedValue {
                        selectedQuoteCollections.wrappedValue.removeAll()
                    }
                    inSelectionMode.wrappedValue.toggle()
                } label: {
                    Text(inSelectionMode.wrappedValue ? "Done" : "Select")
                }
                if inSelectionMode.wrappedValue {
                    Button { showDeleteAlert = true } label: { Text("Delete") }
                    .disabled(selectedQuoteCollections.wrappedValue.isEmpty)
                }
            }
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text(
                    "Deleting the selected quote collections " +
                    "will also delete all of their quotes. " +
                    "This action cannot be undone!"
                ),
                primaryButton: .destructive(Text("Yes, delete")) {
                    withAnimation {
                        viewModel.deleteQuoteCollections(
                            context: context,
                            quoteCollections: selectedQuoteCollections.wrappedValue
                        )
                        selectedQuoteCollections.wrappedValue.removeAll()
                    }
                },
                secondaryButton: .cancel(Text("No, cancel"))
            )
        }
    }
}

struct QuoteCollectionListContainerView: View {
    @Environment(\.managedObjectContext) private var context

    let viewModel = QuoteCollectionListViewModel()

    @State private var searchTerm: String = ""
    @State private var inSelectionMode: Bool = false
    @State private var selectedQuoteCollections: Set<QuoteCollection> = Set<QuoteCollection>()
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
                searchQuery: searchQuery,
                inSelectionMode: $inSelectionMode,
                selectedQuoteCollections: $selectedQuoteCollections
            )
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !inSelectionMode {
                        SortQuoteCollectionsView(
                            selectedSort: $selectedSort,
                            sorts: QuoteCollectionSort.sorts
                        )
                        Button { showAddCollectionView = true } label: { Text("Add") }
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
