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
        text: String? = nil,
        author: String? = nil,
        collection: QuoteCollection? = nil,
        sortBy: QuoteSortByAttribute = QuoteSortByAttribute.dateCreated,
        ascending: Bool = false
    ) -> FetchedResults<Quote> {
        var predicateFormatParts: [String] = []
        var predicateArgs: [Any] = []
        if text != nil {
            predicateFormatParts.append("text CONTAINS[c] %@")
            predicateArgs.append(text!)
        }
        if author != nil {
            predicateFormatParts.append("author CONTAINS[c] %@")
            predicateArgs.append(author!)
        }
        if collection != nil {
            predicateFormatParts.append("collection = %@")
            predicateArgs.append(collection!)
        }
        let predicateFormat: String = predicateFormatParts.joined(separator: " && ")
        @FetchRequest(
            sortDescriptors: [NSSortDescriptor(key: sortBy.rawValue, ascending: ascending)],
            predicate: predicateFormat.isEmpty ? nil : NSPredicate(format: predicateFormat, argumentArray: predicateArgs)
        )
        var quotes: FetchedResults<Quote>
        return quotes
    }
}
