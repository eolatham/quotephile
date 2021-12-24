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
    func addQuoteCollection(
        context: NSManagedObjectContext,
        quoteCollection: QuoteCollection? = nil,
        values: QuoteCollectionValues
    ) -> QuoteCollection {
        let now = Date.now
        let newQuoteCollection: QuoteCollection
        if quoteCollection != nil {
            newQuoteCollection = quoteCollection!
        } else {
            newQuoteCollection = QuoteCollection(context: context)
            newQuoteCollection.dateCreated = now
        }
        newQuoteCollection.dateChanged = now
        newQuoteCollection.name = values.name
        Utility.updateContext(context: context)
        return newQuoteCollection
    }
}
