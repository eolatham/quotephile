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
    @objc var exists: Bool { text != nil }
    @objc var author: String {
        [authorFirstName!, authorLastName!]
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)
    }
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
    @objc var authorFirstNameAscending: String {
        return authorFirstName!.isEmpty ? "ANONYMOUS" : authorFirstName!.uppercased()
    }
    @objc var authorFirstNameDescending: String {
        // Add space to avoid crash upon switching sort mode
        return (authorFirstName!.isEmpty ? "ANONYMOUS" : authorFirstName!.uppercased()) + " "
    }
    @objc var authorLastNameAscending: String {
        return authorLastName!.isEmpty ? "ANONYMOUS" : authorLastName!.uppercased()
    }
    @objc var authorLastNameDescending: String {
        // Add space to avoid crash upon switching sort mode
        return (authorLastName!.isEmpty ? "ANONYMOUS" : authorLastName!.uppercased()) + " "
    }
}
