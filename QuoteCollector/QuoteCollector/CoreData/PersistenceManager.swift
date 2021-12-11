//
//  Persistence.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/7/21.
//

import CoreData

struct PersistenceManager {
    static let shared = PersistenceManager()

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
    
    static var preview: PersistenceManager = {
        let manager = PersistenceManager(inMemory: true)
        let context = manager.container.viewContext
        let addQuoteCollectionViewModel = AddQuoteCollectionViewModel()
        let addQuoteViewModel = AddQuoteViewModel()
        for i in 1..<6 {
            let quoteCollection = addQuoteCollectionViewModel.addQuoteCollection(
                context: context,
                values: QuoteCollectionValues(name: "Quote Collection #\(i)")
            )
            for j in 1..<11 {
                let quote = addQuoteViewModel.addQuote(
                    context: context,
                    values: QuoteValues(
                        collection: quoteCollection,
                        text: "Quote Collection #\(i) - Quote #\(j)"
                    )
                )
            }
        }
        Utility.updateContext(context: context)
        return manager
    }()
}
