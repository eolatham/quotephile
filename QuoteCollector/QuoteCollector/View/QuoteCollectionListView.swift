//
//  ContentView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/7/21.
//

import SwiftUI
import CoreData

struct QuoteCollectionListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var quoteCollections: FetchedResults<QuoteCollection>

    var body: some View {
        NavigationView {
            List {
                ForEach(quoteCollections) { quoteCollection in
                    NavigationLink {
                        QuoteCollectionView(
                            quoteCollection: quoteCollection,
                            quotes: Quote.query(context: viewContext, collection: quoteCollection)
                        )
                    } label: {
                        QuoteCollectionRowView(quoteCollection: quoteCollection)
                    }
                }
                .onDelete(perform: deleteQuoteCollections)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addQuoteCollection) {
                        Label("Add Quote Collection", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Quote Collections")
        }
    }

    private func addQuoteCollection() {
        withAnimation {
            _ = QuoteCollection.create(context: viewContext, name: "Quote Collection")
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteQuoteCollections(offsets: IndexSet) {
        withAnimation {
            offsets.map { quoteCollections[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
