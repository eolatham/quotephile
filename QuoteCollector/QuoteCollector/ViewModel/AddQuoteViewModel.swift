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
        quote.text = values.text
        quote.authorFirstName = values.authorFirstName
        quote.authorLastName = values.authorLastName
        quote.tags = formatTags(tags: values.tags)
        quote.displayQuotationMarks = values.displayQuotationMarks
        quote.displayAuthor = values.displayAuthor
        quote.displayAuthorOnNewLine = values.displayAuthorOnNewLine
        Utility.updateContext(context: context)
        return quote
    }

    /**
     * Transforms the given unformatted comma-separated list of tags into a
     * comma-separated and alphabetically-sorted list of unique and capitalized tags.
     */
    func formatTags(tags: String) -> String {
        return Set(
            tags
            .split(separator: ",")
            .map({ tag in return tag.trimmingCharacters(in: .whitespacesAndNewlines).capitalized })
        )
        .sorted()
        .joined(separator: ", ")
    }
}
