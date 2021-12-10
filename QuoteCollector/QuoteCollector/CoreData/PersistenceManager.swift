//
//  Persistence.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/7/21.
//

import CoreData

struct PersistenceManager {
    static let shared = PersistenceManager()

    static var preview: PersistenceManager = {
        let result = PersistenceManager(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 1..<6 {
            let quoteCollection = QuoteCollection.create(context: viewContext, name: "Quote Collection #\(i)")
            for j in 1..<11 {
                var quote = Quote.create(
                    context: viewContext,
                    collection: quoteCollection,
                    text: "Quote Collection #\(i) - Quote #\(j)",
                    author: "Author"
                )
            }
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "QuoteCollector")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
