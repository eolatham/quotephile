//
//  QuoteCollectionListViewModel.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import CoreData
import SwiftUI

struct QuoteCollectionListViewModel {
    func deleteQuoteCollections(
        context: NSManagedObjectContext,
        quoteCollections: Set<QuoteCollection>
    ) {
        quoteCollections.forEach(context.delete)
        Utility.updateContext(context: context)
    }
}
