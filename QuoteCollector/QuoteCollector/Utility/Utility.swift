//
//  Utility.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import CoreData

struct Utility {
    static func dateToMonthString(date: Date) -> String {
        return date.formatted(.dateTime.month(.wide).year())
    }
    
    static func updateContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
    }

    static func join(strings: [String?], separator: String = "\n") -> String {
        var joined = ""
        for s in strings {
            if s != nil {
                if joined.isEmpty { joined = s! }
                else { joined = joined + separator + s! }
            }
        }
        return joined
    }
}
