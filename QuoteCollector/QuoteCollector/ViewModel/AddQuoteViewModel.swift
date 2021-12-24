//
//  AddQuoteViewModel.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import CoreData

/**
 * For adding and editing quotes.
 */
struct AddQuoteViewModel {
    func addQuote(
        context: NSManagedObjectContext,
        quote: Quote? = nil,
        values: QuoteValues
    ) -> Quote {
        let now = Date.now
        let newQuote: Quote
        if quote != nil {
            newQuote = quote!
        } else {
            newQuote = Quote(context: context)
            newQuote.dateCreated = now
        }
        newQuote.dateChanged = now
        newQuote.collection = values.collection
        newQuote.text = Quote.formatText(text: values.text)
        newQuote.authorFirstName = Quote.formatAuthor(author: values.authorFirstName)
        newQuote.authorLastName = Quote.formatAuthor(author: values.authorLastName)
        newQuote.tags = Quote.formatTags(tags: values.tags)
        newQuote.displayQuotationMarks = values.displayQuotationMarks
        newQuote.displayAuthor = values.displayAuthor
        newQuote.displayAuthorOnNewLine = values.displayAuthorOnNewLine
        Utility.updateContext(context: context)
        return newQuote
    }
}
