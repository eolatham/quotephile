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
    func fetchQuote(
        context: NSManagedObjectContext,
        objectId: NSManagedObjectID
    ) -> Quote? {
        if let quote = context.object(with: objectId)
            as? Quote { return quote }
        return nil
    }
    
    func addQuote(
        context: NSManagedObjectContext,
        objectId: NSManagedObjectID? = nil,
        values: QuoteValues
    ) -> Quote {
        let now = Date.now
        let quote: Quote
        if let quoteId = objectId,
           let fetchedQuote = fetchQuote(
            context: context,
            objectId: quoteId
           ) {
            quote = fetchedQuote
        } else {
            quote = Quote(context: context)
            quote.dateCreated = now
        }
        quote.dateChanged = now
        quote.collection = values.collection
        quote.text = Quote.formatText(text: values.text)
        quote.authorFirstName = Quote.formatAuthor(author: values.authorFirstName)
        quote.authorLastName = Quote.formatAuthor(author: values.authorLastName)
        quote.tags = Quote.formatTags(tags: values.tags)
        quote.displayQuotationMarks = values.displayQuotationMarks
        quote.displayAuthor = values.displayAuthor
        quote.displayAuthorOnNewLine = values.displayAuthorOnNewLine
        Utility.updateContext(context: context)
        return quote
    }
}
