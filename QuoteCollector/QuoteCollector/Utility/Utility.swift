//
//  Utility.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import Foundation

public class Utility {
    public static func dateToDayString(date: Date) -> String {
        return date.formatted(.dateTime.month(.wide).day().year())
    }
}
