//
//  Quote.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/7/21.
//
//

import CoreData

@objc(Quote)
public class Quote: NSManagedObject {
    
    @objc public var dayCreatedAscending: String {
        return Utility.dateToDayString(date:dateCreated!)
    }
    @objc public var dayCreatedDescending: String {
        // Add space to avoid crash upon switching sort mode
        return Utility.dateToDayString(date:dateCreated!) + " "
    }
    @objc public var dayChangedAscending: String {
        return Utility.dateToDayString(date:dateChanged!)
    }
    @objc public var dayChangedDescending: String {
        // Add space to avoid crash upon switching sort mode
        return Utility.dateToDayString(date:dateChanged!) + " "
    }
    @objc public var authorAscending: String {
        return author ?? "None"
    }
    @objc public var authorDescending: String {
        // Add space to avoid crash upon switching sort mode
        return (author ?? "None") + " "
    }
    
    public static func create(
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
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
        return quote
    }
}
