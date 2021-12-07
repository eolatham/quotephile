//
//  QuoteCollectionView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/7/21.
//

import SwiftUI
import CoreData

struct QuoteCollectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var quoteCollection: QuoteCollection
    var quotes: [Quote]
    var body: some View {
        List {
            ForEach(quotes) { quote in
                NavigationLink {
                    QuoteView(quote: quote)
                } label: {
                    QuoteRowView(quote: quote)
                }
            }
            .onDelete(perform: deleteQuotes)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: addQuote) {
                    Label("Add Quote", systemImage: "plus")
                }
            }
        }
        .navigationTitle(quoteCollection.name!)
    }

    private func addQuote() {
        withAnimation {
            _ = Quote.create(context: viewContext, collection: quoteCollection, text: "Hello, World!")
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

    private func deleteQuotes(offsets: IndexSet) {
        withAnimation {
            offsets.map { quotes[$0] }.forEach(viewContext.delete)
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
