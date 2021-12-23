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

    static func trimWhitespace(string: String) -> String {
        return string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .joined(separator: " ")
    }

    static func trimWhitespace(string: Substring) -> String {
        return string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .joined(separator: " ")
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

    static func updateContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
    }
}
