//
//  QuoteListView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/12/21.
//

import SwiftUI

struct QuoteListItemView: View {
    @ObservedObject var quote: Quote
    var inSelectionMode: Bool
    var selectedQuotes: Binding<Set<Quote>>

    var body: some View {
        let isSelected: Bool = selectedQuotes.wrappedValue.contains(quote)
        if inSelectionMode {
            HStack {
                Button {
                    if isSelected { selectedQuotes.wrappedValue.remove(quote) }
                    else { selectedQuotes.wrappedValue.update(with: quote) }
                } label: {
                    Image(
                        systemName: isSelected
                            ? "checkmark.circle.fill"
                            : "checkmark.circle"
                    )
                }
                QuoteRowView(quote: quote)
            }.foregroundColor(isSelected ? .accentColor : .black)
        } else {
            NavigationLink {
                QuoteView(quote: quote)
            } label: {
                QuoteRowView(quote: quote)
            }
        }
    }
}

struct QuoteListView: View {
    @Environment(\.managedObjectContext) private var context

    let viewModel: QuoteListViewModel = QuoteListViewModel()

    @SectionedFetchRequest var quotes: SectionedFetchResults<String, Quote>
    var searchQuery: Binding<String>
    var inSelectionMode: Binding<Bool>
    var selectedQuotes: Binding<Set<Quote>>

    @State private var showEditView: Bool = false
    @State private var showMoveView: Bool = false
    @State private var showDeleteAlert: Bool = false

    var body: some View {
        List {
            ForEach(quotes) { section in
                Section(header: Text(section.id)) {
                    ForEach(section) { quote in
                        QuoteListItemView(
                            quote: quote,
                            inSelectionMode: inSelectionMode.wrappedValue,
                            selectedQuotes: selectedQuotes
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
                        selectedQuotes.wrappedValue.removeAll()
                    }
                    inSelectionMode.wrappedValue.toggle()
                } label: {
                    Text(inSelectionMode.wrappedValue ? "Done" : "Select")
                }
                if inSelectionMode.wrappedValue {
                    let disabled: Bool = selectedQuotes.wrappedValue.isEmpty
                    Button { showEditView = true }
                        label: { Text("Edit") }.disabled(disabled)
                    Button { showMoveView = true }
                        label: { Text("Move") }.disabled(disabled)
                    Button { showDeleteAlert = true }
                        label: { Text("Delete") }.disabled(disabled)
                }
            }
        }
        .sheet(isPresented: $showEditView ) {}  // TODO: render new view here
        .sheet(isPresented: $showMoveView ) {}  // TODO: render new view here
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text(
                    "Are you sure you want to delete the selected " +
                    "quotes? This action cannot be undone!"
                ),
                primaryButton: .destructive(Text("Yes, delete")) {
                    withAnimation {
                        viewModel.deleteQuotes(
                            context: context,
                            quotes: selectedQuotes.wrappedValue
                        )
                        selectedQuotes.wrappedValue.removeAll()
                    }
                },
                secondaryButton: .cancel(Text("No, cancel"))
            )
        }
    }
}

struct AllQuotesView: View {
    @Environment(\.managedObjectContext) private var context

    let viewModel = QuoteListViewModel()

    @State private var searchTerm: String = ""
    @State private var inSelectionMode: Bool = false
    @State private var selectedQuotes: Set<Quote> = Set<Quote>()
    @State private var selectedSort: QuoteSort = QuoteSort.default

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
            searchQuery: searchQuery,
            inSelectionMode: $inSelectionMode,
            selectedQuotes: $selectedQuotes
        )
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if !inSelectionMode {
                    SortQuotesView(
                        selectedSort: $selectedSort,
                        sorts: QuoteSort.sorts
                    )
                }
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
    @State private var inSelectionMode: Bool = false
    @State private var selectedQuotes: Set<Quote> = Set<Quote>()
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
            searchQuery: searchQuery,
            inSelectionMode: $inSelectionMode,
            selectedQuotes: $selectedQuotes
        )
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if !inSelectionMode {
                    SortQuotesView(
                        selectedSort: $selectedSort,
                        sorts: QuoteSort.sorts
                    )
                    Button { showAddQuoteView = true } label: { Text("Add") }
                    Button { showEditCollectionView = true } label: { Text("Edit") }
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
