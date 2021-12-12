//
//  AddQuoteCollectionViewModel.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import CoreData

/**
 * For adding and editing quote collections.
 */
struct AddQuoteCollectionViewModel {
    func fetchQuoteCollection(
        context: NSManagedObjectContext,
        objectId: NSManagedObjectID
    ) -> QuoteCollection? {
        if let quoteCollection = context.object(with: objectId)
            as? QuoteCollection { return quoteCollection }
        return nil
    }
    
    func addQuoteCollection(
        context: NSManagedObjectContext,
        objectId: NSManagedObjectID? = nil,
        values: QuoteCollectionValues
    ) -> QuoteCollection {
        let now = Date.now
        let quoteCollection: QuoteCollection
        if let quoteCollectionId = objectId,
           let fetchedQuoteCollection = fetchQuoteCollection(
            context: context,
            objectId: quoteCollectionId
           ) {
            quoteCollection = fetchedQuoteCollection
        } else {
            quoteCollection = QuoteCollection(context: context)
            quoteCollection.dateCreated = now
        }
        quoteCollection.dateChanged = now
        quoteCollection.name = values.name
        Utility.updateContext(context: context)
        return quoteCollection
    }
}
