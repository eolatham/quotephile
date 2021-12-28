class QuoteValues: Values {
    var collection: QuoteCollection
    var text: String
    var authorFirstName: String
    var authorLastName: String
    var tags: String
    var displayQuotationMarks: Bool
    var displayAuthor: Bool
    var displayAuthorOnNewLine: Bool

    init(
        collection: QuoteCollection,
        text: String,
        authorFirstName: String = "",
        authorLastName: String = "",
        tags: String = "",
        displayQuotationMarks: Bool = true,
        displayAuthor: Bool = true,
        displayAuthorOnNewLine: Bool = true
    ) {
        self.collection = collection
        self.text = text
        self.authorFirstName = authorFirstName
        self.authorLastName = authorLastName
        self.tags = tags
        self.displayQuotationMarks = displayQuotationMarks
        self.displayAuthor = displayAuthor
        self.displayAuthorOnNewLine = displayAuthorOnNewLine
    }

    func formatAndValidate() throws {
        // Format
        text = QuoteValues.formatText(text: text)
        authorFirstName = QuoteValues.formatAuthor(author: authorFirstName)
        authorLastName = QuoteValues.formatAuthor(author: authorLastName)
        tags = QuoteValues.formatTags(tags: tags)
        // Validate
        if text.isEmpty {
            throw ValidationError.withMessage(ErrorMessage.textEmpty)
        }
    }

    /**
     * Trims leading and trailing whitespace from the given string.
     */
    static func formatText(text: String) -> String {
        return Utility.trimWhitespace(string: text)
    }

    /**
     * Trims leading and trailing whitespace from the given string.
     */
    static func formatAuthor(author: String) -> String {
        return Utility.trimWhitespace(string: author)
    }

    /**
     * Transforms the given comma-separated list of tags into
     * a set of unique, nonempty, and capitalized tags.
     */
    static func tagsStringToFormattedSet(tagsString: String) -> Set<String> {
        var formattedSet: Set<String> = Set()
        for tag in tagsString.split(separator: ",") {
            let formattedTag = Utility.trimWhitespace(string: tag).capitalized
            if formattedTag.count > 0 { formattedSet.update(with: formattedTag) }
        }
        return formattedSet
    }

    /**
     * Transforms the given formatted set of tags into a
     * comma-separated and alphabetically-sorted list.
     */
    static func formattedTagsSetToString(tagsSet: Set<String>) -> String {
        return tagsSet.sorted().joined(separator: ", ")
    }

    /**
     * Transforms the given unformatted comma-separated list of tags into a comma-separated
     * and alphabetically-sorted list of unique, nonempty, and capitalized tags.
     */
    static func formatTags(tags: String) -> String {
        return formattedTagsSetToString(
            tagsSet: tagsStringToFormattedSet(tagsString: tags)
        )
    }

    /**
     * Transforms the given comma-separated lists of tags into a comma-separated
     * and alphabetically-sorted list of unique, nonempty, and capitalized tags.
     */
    static func combineTags(tagsStrings: [String]) -> String {
        var tagsSet: Set<String> = []
        for tagsString in tagsStrings {
            for tag in tagsStringToFormattedSet(tagsString: tagsString) {
                tagsSet.update(with: tag)
            }
        }
        return formattedTagsSetToString(tagsSet: tagsSet)
    }

    /**
     * Returns a formatted version of `from` without any tags from `remove`.
     */
    static func removeTags(remove: String, from: String) -> String {
        var tagsSet = QuoteValues.tagsStringToFormattedSet(tagsString: from)
        for tag in QuoteValues.tagsStringToFormattedSet(tagsString: remove) {
            tagsSet.remove(tag)
        }
        return formattedTagsSetToString(tagsSet: tagsSet)
    }
}
