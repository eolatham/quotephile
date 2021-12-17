//
//  QuoteCollection.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/7/21.
//
//

import CoreData

@objc(QuoteCollection)
class QuoteCollection: NSManagedObject {
    @objc var exists: Bool { name != nil }
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
    @objc var nameFirstCharacterAscending: String {
        return name!.first!.uppercased()
    }
    @objc var nameFirstCharacterDescending: String {
        // Add space to avoid crash upon switching sort mode
        return name!.first!.uppercased() + " "
    }
}
