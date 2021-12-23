//
//  BulkMoveQuotesViewModel.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/23/21.
//

import CoreData

struct BulkMoveQuotesViewModel {
    func moveQuotes(
        context: NSManagedObjectContext,
        quotes: [Quote],
        newCollection: QuoteCollection
    ) {
        quotes.forEach({ quote in quote.collection = newCollection })
        Utility.updateContext(context: context)
    }
}
