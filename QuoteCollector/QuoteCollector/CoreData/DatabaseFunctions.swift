import CoreData

struct DatabaseFunctions {
    static func updateContext(context: NSManagedObjectContext) {
        do { try context.save() }
        catch { print("Save error: \(error)") }
    }

    /**
     * For adding or editing a quote.
     * Formats and validates values before saving.
     */
    static func addQuote(
        context: NSManagedObjectContext,
        quote: Quote? = nil,
        values: QuoteValues
    ) throws -> Quote {
        values.format()
        try values.validate()
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
        newQuote.text = values.text
        newQuote.authorFirstName = values.authorFirstName
        newQuote.authorLastName = values.authorLastName
        newQuote.tags = values.tags
        newQuote.displayQuotationMarks = values.displayQuotationMarks
        newQuote.displayAuthor = values.displayAuthor
        newQuote.displayAuthorOnNewLine = values.displayAuthorOnNewLine
        updateContext(context: context)
        return newQuote
    }

    /**
     * Formats and validates values before saving.
     */
    static func editQuote(
        context: NSManagedObjectContext,
        quote: Quote,
        values: QuoteValues
    ) throws {
        try _ = addQuote(context: context, quote: quote, values: values)
    }

    /**
     * For adding or editing a quote collection.
     * Formats and validates values before saving.
     */
    static func addQuoteCollection(
        context: NSManagedObjectContext,
        quoteCollection: QuoteCollection? = nil,
        values: QuoteCollectionValues
    ) throws -> QuoteCollection {
        values.format()
        try values.validate()
        let now = Date.now
        let newQuoteCollection: QuoteCollection
        if quoteCollection != nil {
            newQuoteCollection = quoteCollection!
        } else {
            newQuoteCollection = QuoteCollection(context: context)
            newQuoteCollection.dateCreated = now
        }
        newQuoteCollection.dateChanged = now
        newQuoteCollection.name = values.name
        updateContext(context: context)
        return newQuoteCollection
    }

    /**
     * Formats and validates values before saving.
     */
    static func editQuoteCollection(
        context: NSManagedObjectContext,
        quoteCollection: QuoteCollection,
        values: QuoteCollectionValues
    ) throws {
        try _ = addQuoteCollection(
            context: context,
            quoteCollection: quoteCollection,
            values: values
        )
    }

    static func deleteQuotes(
        context: NSManagedObjectContext,
        quotes: Set<Quote>
    ) {
        quotes.forEach(context.delete)
        updateContext(context: context)
    }

    static func deleteQuoteCollections(
        context: NSManagedObjectContext,
        quoteCollections: Set<QuoteCollection>
    ) {
        quoteCollections.forEach(context.delete)
        updateContext(context: context)
    }

    static func editQuotes(
        context: NSManagedObjectContext,
        quotes: Set<Quote>,
        newAuthorFirstName: String? = nil,
        newAuthorLastName: String? = nil,
        newTags: String? = nil,
        addTags: String? = nil,
        removeTags: String? = nil
    ) throws {
        if newAuthorFirstName != nil {
            try QuoteValues.validateAuthorFirstName(authorFirstName: newAuthorFirstName!)
        }
        if newAuthorLastName != nil {
            try QuoteValues.validateAuthorLastName(authorLastName: newAuthorLastName!)
        }
        if newTags != nil {
            try QuoteValues.validateTags(tags: newTags!)
        }
        // TODO: add validation for addTags... (before changing any quotes)
        for quote in quotes {
            // Author logic
            if newAuthorFirstName != nil {
                quote.authorFirstName = QuoteValues.formatAuthor(author: newAuthorFirstName!)
            }
            if newAuthorLastName != nil {
                quote.authorLastName = QuoteValues.formatAuthor(author: newAuthorLastName!)
            }
            // Tags logic
            if newTags != nil {
                quote.tags = QuoteValues.formatTags(tags: newTags!)
            } else if addTags != nil {
                quote.tags = QuoteValues.formatTags(tags: "\(quote.tags!),\(addTags!)")
            } else if removeTags != nil {
                var tagSet = QuoteValues.tagsStringToFormattedSet(tags: quote.tags!)
                for tag in QuoteValues.tagsStringToFormattedSet(tags: removeTags!) {
                    tagSet.remove(tag)
                }
                quote.tags = QuoteValues.formattedSetOfTagsToString(tags: tagSet)
            }
        }
        updateContext(context: context)
    }

    static func moveQuotes(
        context: NSManagedObjectContext,
        quotes: Set<Quote>,
        newCollection: QuoteCollection
    ) {
        quotes.forEach({ quote in quote.collection = newCollection })
        updateContext(context: context)
    }
}
