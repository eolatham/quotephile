//
//  BulkEditQuotesViewModel.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/23/21.
//

import CoreData

struct BulkEditQuotesViewModel {
    func editQuotes(
        context: NSManagedObjectContext,
        quotes: [Quote],
        newAuthorFirstName: String? = nil,
        newAuthorLastName: String? = nil,
        newTags: String? = nil,
        addTags: String? = nil,
        removeTags: String? = nil
    ) {
        for quote in quotes {
            // Author logic
            if newAuthorFirstName != nil {
                quote.authorFirstName = Quote.formatAuthor(author: newAuthorFirstName!)
            }
            if newAuthorLastName != nil {
                quote.authorLastName = Quote.formatAuthor(author: newAuthorLastName!)
            }
            // Tags logic
            if newTags != nil {
                quote.tags = Quote.formatTags(tags: newTags!)
            } else if addTags != nil {
                quote.tags = Quote.formatTags(tags: "\(quote.tags!),\(addTags!)")
            } else if removeTags != nil {
                var tagSet = Quote.tagsStringToFormattedSet(tags: quote.tags!)
                for tag in Quote.tagsStringToFormattedSet(tags: removeTags!) {
                    tagSet.remove(tag)
                }
                quote.tags = Quote.formattedSetOfTagsToString(tags: tagSet)
            }
        }
        Utility.updateContext(context: context)
    }
}
