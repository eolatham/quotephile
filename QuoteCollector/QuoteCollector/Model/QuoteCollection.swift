//
//  QuoteCollection.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/6/21.
//

import Foundation

struct QuoteCollection: Hashable, Codable, Identifiable {
    let id: UUID
    var name: String
    var quotes: [Quote]
    
    init(name: String, quotes: [Quote] = []) {
        self.id = UUID()
        self.name = name
        self.quotes = quotes
    }
}
