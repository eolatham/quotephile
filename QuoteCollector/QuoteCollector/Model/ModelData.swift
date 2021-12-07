//
//  ModelData.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/6/21.
//

import Foundation

var QUOTE_COLLECTIONS: [QuoteCollection] = loadQuoteCollections()

func loadQuoteCollections() -> [QuoteCollection] {
    var quoteCollections: [QuoteCollection] = []
    for i in [1, 2, 3] {
        var quotes: [Quote] = []
        if let url = Bundle.main.url(forResource: "quoteCollection\(i)", withExtension: "txt") {
            do {
                let data = try String(contentsOfFile: url.path, encoding: .utf8)
                for line in data.components(separatedBy: .newlines) {
                    quotes.append(Quote(text: line))
                }
            } catch {
                fatalError("Failed to load quote collections:\n\(error)")
            }
        }
        quoteCollections.append(QuoteCollection(name: "Quote Collection #\(i)", quotes: quotes))
    }
    return quoteCollections
}
