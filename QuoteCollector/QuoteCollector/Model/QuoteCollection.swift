//
//  QuoteCollection.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/6/21.
//

import Foundation

struct QuoteCollection: Hashable, Codable {
    var id: UUID
    var name: String
    var quotes: [Quote]
}
