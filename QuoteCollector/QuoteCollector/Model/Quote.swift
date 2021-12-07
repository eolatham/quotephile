//
//  Quote.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/6/21.
//

import Foundation

struct Quote: Hashable, Codable {
    var id: UUID
    var text: String
}
