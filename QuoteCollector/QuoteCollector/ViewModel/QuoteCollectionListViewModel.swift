//
//  ListViewModel.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import CoreData
import SwiftUI

struct QuoteCollectionListViewModel {
    func deleteQuoteCollection(
        context: NSManagedObjectContext,
        section: SectionedFetchResults<String, QuoteCollection>.Element,
        indexSet: IndexSet
    ) {
        indexSet.map { section[$0] }.forEach(context.delete)
        Utility.updateContext(context: context)
    }
}
