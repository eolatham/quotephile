//
//  Quote.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/7/21.
//
//

import CoreData

@objc(Quote)
class Quote: NSManagedObject {
    @objc var dayCreatedAscending: String {
        return Utility.dateToDayString(date:dateCreated!)
    }
    @objc var dayCreatedDescending: String {
        // Add space to avoid crash upon switching sort mode
        return Utility.dateToDayString(date:dateCreated!) + " "
    }
    @objc var dayChangedAscending: String {
        return Utility.dateToDayString(date:dateChanged!)
    }
    @objc var dayChangedDescending: String {
        // Add space to avoid crash upon switching sort mode
        return Utility.dateToDayString(date:dateChanged!) + " "
    }
    @objc var authorAscending: String {
        return author!.isEmpty ? "None" : author!.uppercased()
    }
    @objc var authorDescending: String {
        // Add space to avoid crash upon switching sort mode
        return (author!.isEmpty ? "None" : author!.uppercased()) + " "
    }
}
