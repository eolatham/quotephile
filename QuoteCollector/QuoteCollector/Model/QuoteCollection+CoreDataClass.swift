//
//  QuoteCollection+CoreDataClass.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/7/21.
//
//

import Foundation
import CoreData

@objc(QuoteCollection)
public class QuoteCollection: NSManagedObject {
    static func create(context: NSManagedObjectContext, name: String) -> QuoteCollection {
        let quoteCollection = QuoteCollection(context: context)
        quoteCollection.id = UUID()
        let now = Date.now
        quoteCollection.dateCreated = now
        quoteCollection.dateChanged = now
        quoteCollection.name = name
        return quoteCollection
    }
}
