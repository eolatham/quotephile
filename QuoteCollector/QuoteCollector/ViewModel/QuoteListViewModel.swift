//
//  QuoteListViewModel.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import CoreData
import SwiftUI

struct QuoteListViewModel {
    func deleteQuotes(context: NSManagedObjectContext, quotes: [Quote]) {
        quotes.forEach(context.delete)
        Utility.updateContext(context: context)
    }
}
