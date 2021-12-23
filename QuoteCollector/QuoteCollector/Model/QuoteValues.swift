//
//  QuoteValues.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

/**
 * User-editable values.
 */
struct QuoteValues {
    var collection: QuoteCollection
    var text: String
    var authorFirstName: String = ""
    var authorLastName: String = ""
    var tags: String = ""
    var displayQuotationMarks: Bool = true
    var displayAuthor: Bool = true
    var displayAuthorOnNewLine: Bool = true
}
