import CoreData

enum EditMode: String {
    case replace = "replace"
    case add = "add"
    case remove = "remove"
}

struct DatabaseFunctions {
    static func commitChanges(context: NSManagedObjectContext) {
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
        values: QuoteValues,
        commitChangesImmediately: Bool = true
    ) throws -> Quote {
        try values.formatAndValidate()
        let now = Date.now
        let newQuote: Quote
        if quote != nil {
            if values.equals(quote: quote!) {
                return quote!
            }
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
        newQuote.work = values.work
        newQuote.tags = values.tags
        newQuote.displayQuotationMarks = values.displayQuotationMarks
        newQuote.displayAttribution = values.displayAttribution
        newQuote.displayAttributionOnNewLine = values.displayAttributionOnNewLine
        if commitChangesImmediately { commitChanges(context: context) }
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
            if values.equals(quoteCollection: quoteCollection!) {
                return quoteCollection!
            }
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
        commitChanges(context: context)
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
        commitChanges(context: context)
    }

    static func deleteQuotes(
        context: NSManagedObjectContext,
        quotes: Set<Quote>
    ) {
        quotes.forEach(context.delete)
        commitChanges(context: context)
    }

    static func deleteQuoteCollection(
        context: NSManagedObjectContext,
        quoteCollection: QuoteCollection
    ) {
        QuoteSort.deleteUserDefault(quoteCollection: quoteCollection)
        context.delete(quoteCollection)
        commitChanges(context: context)
    }

    static func deleteQuoteCollections(
        context: NSManagedObjectContext,
        quoteCollections: Set<QuoteCollection>
    ) {
        for quoteCollection in quoteCollections {
            QuoteSort.deleteUserDefault(quoteCollection: quoteCollection)
            context.delete(quoteCollection)
        }
        commitChanges(context: context)
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
        fallbackWork: String = "",
        tags: String = ""
    ) {
        var text: String = ""
        var authorFirstName: String = ""
        var authorLastName: String = ""
        var work: String = ""
        var inAttributionDelimiter: Bool = false
        var inAuthorFirstName: Bool = false
        var inAuthorLastName: Bool = false
        var inWork: Bool = false
        for c in "\(quotes)\n" {
            if c == "\n" {
                if authorLastName.isEmpty {
                    if authorFirstName.isEmpty {
                        authorFirstName = fallbackAuthorFirstName
                        authorLastName = fallbackAuthorLastName
                    } else if authorFirstName.lowercased() == "anonymous" {
                        authorFirstName = ""
                        authorLastName = ""
                    }
                }
                do {
                    try _ = addQuote(
                        context: context,
                        values: QuoteValues(
                            collection: quoteCollection,
                            text: text.trimmingCharacters(in: ["—"]),
                            authorFirstName: authorFirstName,
                            authorLastName: authorLastName,
                            work: work,
                            tags: tags
                        ),
                        commitChangesImmediately: false // Very important!
                    )
                } catch {
                    print(
                        "Skipping malformed or duplicate quote. " +
                        "Details: \(error)"
                    )
                }
                text = ""
                authorFirstName = ""
                authorLastName = ""
                work = ""
                inAttributionDelimiter = false
                inAuthorFirstName = false
                inAuthorLastName = false
                inWork = false
            } else if inAuthorFirstName {
                if c == "," {
                    // End of first name
                    inAuthorFirstName = false
                    inWork = true
                } else if c.isWhitespace {
                    if !authorFirstName.isEmpty {
                        // End of first name
                        inAuthorFirstName = false
                        inAuthorLastName = true
                    }
                    // Still looking for start of first name
                } else {
                    authorFirstName.append(c)
                }
            } else if inAuthorLastName {
                if c == "," {
                    // End of last name
                    inAuthorLastName = false
                    inWork = true
                } else {
                    authorLastName.append(c)
                }
            } else if inWork {
                work.append(c)
            } else if c == "—" {
                if inAttributionDelimiter {
                    // Second consecutive long dash; author is next
                    inAttributionDelimiter = false
                    inAuthorFirstName = true
                } else {
                    // Single long dash; maybe in author delimitter
                    inAttributionDelimiter = true
                    text.append(c)
                }
            } else {
                inAttributionDelimiter = false
                text.append(c)
            }
        }
        commitChanges(context: context)
    }

    static func bulkEditQuotes(
        context: NSManagedObjectContext,
        quotes: Set<Quote>,
        newAuthorFirstName: String? = nil,
        newAuthorLastName: String? = nil,
        newWork: String? = nil,
        tags: String? = nil,
        tagsMode: EditMode = EditMode.replace
    ) {
        if newAuthorFirstName == nil && newAuthorLastName == nil
           && newWork == nil && tags == nil { return }
        let now = Date.now
        var formattedNewAuthorFirstName: String? = nil
        var formattedNewAuthorLastName: String? = nil
        var formattedNewWork: String? = nil
        var formattedTags: String? = nil
        if newAuthorFirstName != nil {
            formattedNewAuthorFirstName = QuoteValues.formatAuthor(author: newAuthorFirstName!)
        }
        if newAuthorLastName != nil {
            formattedNewAuthorLastName = QuoteValues.formatAuthor(author: newAuthorLastName!)
        }
        if newWork != nil {
            formattedNewWork = QuoteValues.formatWork(work: newWork!)
        }
        if tags != nil {
            formattedTags = QuoteValues.formatTags(tags: tags!)
        }
        for quote in quotes {
            quote.dateChanged = now
            if formattedNewAuthorFirstName != nil {
                quote.authorFirstName = formattedNewAuthorFirstName!
            }
            if formattedNewAuthorLastName != nil {
                quote.authorLastName = formattedNewAuthorLastName!
            }
            if formattedNewWork != nil {
                quote.work = formattedNewWork!
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
        commitChanges(context: context)
    }

    static func bulkMoveQuotes(
        context: NSManagedObjectContext,
        quotes: Set<Quote>,
        newCollection: QuoteCollection
    ) {
        let now = Date.now
        for quote in quotes {
            if quote.collection! != newCollection {
                quote.dateChanged = now
                quote.collection = newCollection
            }
        }
        commitChanges(context: context)
    }

    /**
     * Creates a backup file containing all currently saved quote collection data.
     */
    static func backup(context: NSManagedObjectContext) -> PlainTextDocument {
        let codableCollections = fetchQuoteCollections(context: context).map({ c in c.toCodable() })
        let encoded = try! JSONEncoder().encode(codableCollections)
        return PlainTextDocument(text: String(decoding: encoded, as: UTF8.self))
    }

    /**
     * Restores quote collections from the given backup file, deleting all existing ones if successful.
     */
    static func restore(context: NSManagedObjectContext, backup: PlainTextDocument) throws {
        let decoded = try JSONDecoder().decode([CodableQuoteCollection].self, from: backup.data)
        fetchQuoteCollections(context: context).forEach({ qc in context.delete(qc) })
        for codableQuoteCollection in decoded {
            let _ = QuoteCollection.fromCodable(context: context, codable: codableQuoteCollection)
        }
        commitChanges(context: context)
    }
}
