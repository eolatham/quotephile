import CoreData

struct DatabaseFunctions {
    static func updateContext(context: NSManagedObjectContext) {
        do { try context.save() }
        catch { print("Save error: \(error)") }
    }

    /**
     * For adding and editing a quote.
     */
    static func addQuote(
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
        updateContext(context: context)
        return newQuote
    }

    static func editQuote(
        context: NSManagedObjectContext,
        quote: Quote,
        values: QuoteValues
    ) { _ = addQuote(context: context, quote: quote, values: values) }

    /**
     * For adding and editing a quote collection.
     */
    static func addQuoteCollection(
        context: NSManagedObjectContext,
        quoteCollection: QuoteCollection? = nil,
        values: QuoteCollectionValues
    ) -> QuoteCollection {
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

    static func editQuoteCollection(
        context: NSManagedObjectContext,
        quoteCollection: QuoteCollection,
        values: QuoteCollectionValues
    ) {
        _ = addQuoteCollection(
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
