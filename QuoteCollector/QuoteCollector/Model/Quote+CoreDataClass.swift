//
//  Quote+CoreDataClass.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/7/21.
//
//

import Foundation
import CoreData
import SwiftUI

enum QuoteSortByAttribute: String {
    case text = "text"
    case author = "author"
    case dateCreated = "dateCreated"
    case dateChanged = "dateChanged"
}

@objc(Quote)
public class Quote: NSManagedObject {
    
    static func create(
        context: NSManagedObjectContext,
        collection: QuoteCollection,
        text: String,
        author: String? = nil
    ) -> Quote {
        let quote = Quote(context: context)
        quote.id = UUID()
        let now = Date.now
        quote.dateCreated = now
        quote.dateChanged = now
        quote.collection = collection
        quote.text = text
        quote.author = author
        return quote
    }
    
    static func query(
        context: NSManagedObjectContext,
        collection: QuoteCollection? = nil,
        author: String? = nil,
        text: String? = nil,
        sortBy: QuoteSortByAttribute = QuoteSortByAttribute.dateCreated,
        ascending: Bool = false
    ) -> [Quote] {
        var subpredicates: [NSPredicate] = []
        if collection != nil {
            subpredicates.append(NSPredicate(format: "collection = %@", collection!))
        }
        if author != nil {
            subpredicates.append(NSPredicate(format: "author CONTAINS[c] %@", author!))
        }
        if text != nil {
            subpredicates.append(NSPredicate(format: "text CONTAINS[c] %@", text!))
        }
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortBy.rawValue, ascending: ascending)]
        do { return try context.fetch(fetchRequest) }
        catch { return [] }
    }
}
