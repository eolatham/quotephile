//
//  Utility.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import CoreData

struct Utility {
    static func dateToDayString(date: Date) -> String {
        return date.formatted(.dateTime.month(.wide).day().year())
    }
    
    static func updateContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
    }
}
