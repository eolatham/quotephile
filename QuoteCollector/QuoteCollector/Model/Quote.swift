//
//  Quote.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/6/21.
//

import Foundation

struct Quote: Hashable, Codable, Identifiable {
    let id: UUID
    let dateCreated: Date
    var dateChanged: Date
    var text: String
    var author: String?
    
    init(text: String, author: String? = nil) {
        self.id = UUID()
        let now = Date.now
        self.dateCreated = now
        self.dateChanged = now
        self.text = text
        self.author = author
    }
}
