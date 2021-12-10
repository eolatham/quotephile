//
//  QuoteCollection.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/7/21.
//
//

import CoreData

@objc(QuoteCollection)
public class QuoteCollection: NSManagedObject {
    
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
    
    @objc public var nameAscending: String {
        return name!
    }
    @objc public var nameDescending: String {
        // Add space to avoid crash upon switching sort mode
        return name! + " "
    }
    
    public static func create(context: NSManagedObjectContext, name: String) -> QuoteCollection {
        let quoteCollection = QuoteCollection(context: context)
        quoteCollection.id = UUID()
        let now = Date.now
        quoteCollection.dateCreated = now
        quoteCollection.dateChanged = now
        quoteCollection.name = name
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
        return quoteCollection
    }
}
