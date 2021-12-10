//
//  QuoteCollection+CoreDataClass.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/7/21.
//
//

import Foundation
import CoreData
import SwiftUI

enum QuoteCollectionSortByAttribute: String {
    case name = "name"
    case dateCreated = "dateCreated"
    case dateChanged = "dateChanged"
}

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
    
    static func query(
        context: NSManagedObjectContext,
        name: String? = nil,
        sortBy: QuoteCollectionSortByAttribute = QuoteCollectionSortByAttribute.dateCreated,
        ascending: Bool = false
    ) -> FetchedResults<QuoteCollection> {
        @FetchRequest(
            sortDescriptors: [NSSortDescriptor(key: sortBy.rawValue, ascending: ascending)],
            predicate: name == nil ? nil : NSPredicate(format: "name CONTAINS[c] %@", name!)
        )
        var quoteCollections: FetchedResults<QuoteCollection>
        return quoteCollections
    }
}
