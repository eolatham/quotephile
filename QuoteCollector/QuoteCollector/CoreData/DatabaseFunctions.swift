import CoreData

enum EditMode: String {
    case replace = "replace"
    case add = "add"
    case remove = "remove"
}

struct DatabaseFunctions {
    static func updateContext(context: NSManagedObjectContext) {
        do { try context.save() }
        catch { print("Save error: \(error)") }
    }

    static func assertUniqueQuoteText(context: NSManagedObjectContext, text: String) throws {
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "text LIKE %@", text)
        let quotes: [Quote]
        do { quotes = try context.fetch(fetchRequest) }
        catch { quotes = [] }
        if !quotes.isEmpty {
            throw ValidationError.withMessage(ErrorMessage.quoteExists)
        }
    }

    static func assertUniqueQuoteCollectionName(context: NSManagedObjectContext, name: String) throws {
        let fetchRequest: NSFetchRequest<QuoteCollection> = QuoteCollection.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name LIKE %@", name)
        let quoteCollections: [QuoteCollection]
        do { quoteCollections = try context.fetch(fetchRequest) }
        catch { quoteCollections = [] }
        if !quoteCollections.isEmpty {
            throw ValidationError.withMessage(ErrorMessage.quoteCollectionExists)
        }
    }

    /**
     * Returns all existing quote collections sorted by name.
     */
    static func fetchQuoteCollections(context: NSManagedObjectContext) -> [QuoteCollection] {
        let fetchRequest: NSFetchRequest<QuoteCollection> = QuoteCollection.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \QuoteCollection.name, ascending: true)]
        let quoteCollections: [QuoteCollection]
        do { quoteCollections = try context.fetch(fetchRequest) }
        catch { quoteCollections = [] }
        return quoteCollections
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
        try values.formatAndValidate()
        let now = Date.now
        let newQuote: Quote
        if quote != nil {
            if values.text != quote!.text! {
                try assertUniqueQuoteText(context: context, text: values.text)
            }
            newQuote = quote!
        } else {
            try assertUniqueQuoteText(context: context, text: values.text)
            newQuote = Quote(context: context)
            newQuote.dateCreated = now
            newQuote.id = UUID()
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
        try values.formatAndValidate()
        let now = Date.now
        let newQuoteCollection: QuoteCollection
        if quoteCollection != nil {
            if values.name != quoteCollection!.name! {
                try assertUniqueQuoteCollectionName(
                    context: context,
                    name: values.name
                )
            }
            newQuoteCollection = quoteCollection!
        } else {
            try assertUniqueQuoteCollectionName(
                context: context,
                name: values.name
            )
            newQuoteCollection = QuoteCollection(context: context)
            newQuoteCollection.dateCreated = now
            newQuoteCollection.id = UUID()
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

    static func deleteQuote(
        context: NSManagedObjectContext,
        quote: Quote
    ) {
        context.delete(quote)
        updateContext(context: context)
    }

    static func deleteQuotes(
        context: NSManagedObjectContext,
        quotes: Set<Quote>
    ) {
        quotes.forEach(context.delete)
        updateContext(context: context)
    }

    static func deleteQuoteCollection(
        context: NSManagedObjectContext,
        quoteCollection: QuoteCollection
    ) {
        QuoteSort.deleteUserDefault(quoteCollection: quoteCollection)
        context.delete(quoteCollection)
        updateContext(context: context)
    }

    static func deleteQuoteCollections(
        context: NSManagedObjectContext,
        quoteCollections: Set<QuoteCollection>
    ) {
        for quoteCollection in quoteCollections {
            QuoteSort.deleteUserDefault(quoteCollection: quoteCollection)
            context.delete(quoteCollection)
        }
        updateContext(context: context)
    }

    /**
     * Adds a quote to `quoteCollection` for each line of text in `quotes`.
     * - `quotes` is expected to be formatted as a line-delimitted list of quotes
     * with authors attributed after two long dashes, like the following example:
     * ```
     * """
     * This is a good quote. ——Author Name
     * This is another good one. ——Author Name
     * And this one is anonymous.
     * ...
     * """
     * ```
     * - Empty lines and duplicate quotes in `quotes` are ignored.
     * - `fallbackAuthorFirstName` and `fallbackAuthorLastName` are used
     *   to assign author values for quotes that do not have authors attributed in the text.
     * - `tags` are assigned to all added quotes.
     */
    static func bulkAddQuotes(
        context: NSManagedObjectContext,
        quoteCollection: QuoteCollection,
        quotes: String,
        fallbackAuthorFirstName: String = "",
        fallbackAuthorLastName: String = "",
        tags: String = ""
    ) {
        let pattern = "(.+?)(?:$|——\\s*(\\S+)(.*))"
        let regex = try! NSRegularExpression(pattern: pattern)
        for line in quotes.split(separator: "\n") {
            let line = String(line).trimmingCharacters(in: .whitespaces)
            if line.isEmpty { continue }
            let range = NSRange(location: 0, length: line.utf16.count)
            let match = regex.firstMatch(in: line, options: [], range: range)
            if match == nil { continue }
            let values = QuoteValues(
                collection: quoteCollection,
                text: "",
                authorFirstName: fallbackAuthorFirstName,
                authorLastName: fallbackAuthorLastName,
                tags: tags
            )
            if let textRange = Range(match!.range(at: 1), in: line) {
                values.text = Utility.cleanWhitespace(
                    string: String(line[textRange])
                )
            }
            if let authorFirstNameRange = Range(match!.range(at: 2), in: line) {
                values.authorFirstName = String(line[authorFirstNameRange])
            }
            if let authorLastNameRange = Range(match!.range(at: 3), in: line) {
                values.authorLastName = Utility.cleanWhitespace(
                    string: String(line[authorLastNameRange])
                )
            }
            do {
                try _ = addQuote(context: context, values: values)
            } catch {
                print(
                    "Skipping malformed or duplicate quote: \(values)\n" +
                    "Details: \(error)"
                )
            }
        }
    }

    static func bulkEditQuotes(
        context: NSManagedObjectContext,
        quotes: Set<Quote>,
        newAuthorFirstName: String? = nil,
        newAuthorLastName: String? = nil,
        tags: String? = nil,
        tagsMode: EditMode = EditMode.replace
    ) {
        var formattedNewAuthorFirstName: String? = nil
        var formattedNewAuthorLastName: String? = nil
        var formattedTags: String? = nil
        if newAuthorFirstName != nil {
            formattedNewAuthorFirstName = QuoteValues.formatAuthor(author: newAuthorFirstName!)
        }
        if newAuthorLastName != nil {
            formattedNewAuthorLastName = QuoteValues.formatAuthor(author: newAuthorLastName!)
        }
        if tags != nil {
            formattedTags = QuoteValues.formatTags(tags: tags!)
        }
        for quote in quotes {
            if formattedNewAuthorFirstName != nil {
                quote.authorFirstName = formattedNewAuthorFirstName!
            }
            if formattedNewAuthorLastName != nil {
                quote.authorLastName = formattedNewAuthorLastName!
            }
            if formattedTags != nil {
                switch tagsMode {
                case .replace:
                    quote.tags = formattedTags!
                case .add:
                    quote.tags = QuoteValues.combineTags(tagsStrings: [quote.tags!, formattedTags!])
                case .remove:
                    quote.tags = QuoteValues.removeTags(remove: formattedTags!, from: quote.tags!)
                }
            }
        }
        updateContext(context: context)
    }

    static func bulkMoveQuotes(
        context: NSManagedObjectContext,
        quotes: Set<Quote>,
        newCollection: QuoteCollection
    ) {
        quotes.forEach({ quote in quote.collection = newCollection })
        updateContext(context: context)
    }
}
