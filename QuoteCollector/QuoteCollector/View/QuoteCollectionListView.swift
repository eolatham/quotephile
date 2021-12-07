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

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \QuoteCollection.name, ascending: true)],
        animation: .default)
    private var quoteCollections: FetchedResults<QuoteCollection>

    var body: some View {
        NavigationView {
            List {
                ForEach(quoteCollections) { quoteCollection in
                    NavigationLink {
                        QuoteCollectionView(
                            quoteCollection: quoteCollection,
                            quotes: Array(quoteCollection.quotes as? Set<Quote> ?? [])
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
