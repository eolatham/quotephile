//
//  Quote+CoreDataClass.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/7/21.
//
//

import Foundation
import CoreData

@objc(Quote)
public class Quote: NSManagedObject {
    static func create(
        context: NSManagedObjectContext,
        collection: QuoteCollection,
        text: String,
        author: String? = nil) -> Quote
    {
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
}
