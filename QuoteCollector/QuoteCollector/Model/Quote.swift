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
    @objc var monthCreatedAscending: String {
        return Utility.dateToMonthString(date:dateCreated!)
    }
    @objc var monthCreatedDescending: String {
        // Add space to avoid crash upon switching sort mode
        return Utility.dateToMonthString(date:dateCreated!) + " "
    }
    @objc var monthChangedAscending: String {
        return Utility.dateToMonthString(date:dateChanged!)
    }
    @objc var monthChangedDescending: String {
        // Add space to avoid crash upon switching sort mode
        return Utility.dateToMonthString(date:dateChanged!) + " "
    }
    @objc var authorAscending: String {
        return author!.isEmpty ? "None" : author!.uppercased()
    }
    @objc var authorDescending: String {
        // Add space to avoid crash upon switching sort mode
        return (author!.isEmpty ? "None" : author!.uppercased()) + " "
    }
}
