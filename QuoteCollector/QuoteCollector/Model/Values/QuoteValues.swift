/**
 * A class encapsulating user-editable quote values
 * and methods for formatting and validating them.
 */
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

    /**
     * Formats all attributes that require formatting.
     * To be used when saving a quote.
     */
    func format() {
        text = QuoteValues.formatText(text: text)
        authorFirstName = QuoteValues.formatAuthor(author: authorFirstName)
        authorLastName = QuoteValues.formatAuthor(author: authorLastName)
        tags = QuoteValues.formatTags(tags: tags)
    }

    /**
     * Validates all attributes that require validation.
     * To be used when saving a quote.
     */
    func validate() throws {
        try QuoteValues.validateText(text: text)
        try QuoteValues.validateAuthorFirstName(authorFirstName: authorFirstName)
        try QuoteValues.validateAuthorLastName(authorLastName: authorLastName)
        try QuoteValues.validateTags(tags: tags)
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
    static func tagsStringToFormattedSet(tags: String) -> Set<String> {
        var formattedSet: Set<String> = Set()
        for tag in tags.split(separator: ",") {
            let formattedTag = Utility.trimWhitespace(string: tag).capitalized
            if formattedTag.count > 0 { formattedSet.update(with: formattedTag) }
        }
        return formattedSet
    }

    /**
     * Transforms the given formatted set of tags into a
     * comma-separated and alphabetically-sorted list.
     */
    static func formattedSetOfTagsToString(tags: Set<String>) -> String {
        return tags.sorted().joined(separator: ", ")
    }

    /**
     * Transforms the given unformatted comma-separated list of tags into a comma-separated
     * and alphabetically-sorted list of unique, nonempty, and capitalized tags.
     */
    static func formatTags(tags: String) -> String {
        return formattedSetOfTagsToString(
            tags: tagsStringToFormattedSet(tags: tags)
        )
    }

    /**
     * Validates the length of the given text string.
     */
    static func validateText(text: String) throws {
        if text.count < 1 {
            throw ValidationError.withMessage(ErrorMessage.textEmpty)
        }
        else if text.count > 10000 {
            throw ValidationError.withMessage(ErrorMessage.textTooLong)
        }
    }

    /**
     * Validates the length of the given author first name string.
     */
    static func validateAuthorFirstName(authorFirstName: String) throws {
        if authorFirstName.count > 500 {
            throw ValidationError.withMessage(ErrorMessage.authorFirstNameTooLong)
        }
    }

    /**
     * Validates the length of the given author last name string.
     */
    static func validateAuthorLastName(authorLastName: String) throws {
        if authorLastName.count > 500 {
            throw ValidationError.withMessage(ErrorMessage.authorLastNameTooLong)
        }
    }

    /**
     * Validates the length of the given tags string.
     */
    static func validateTags(tags: String) throws {
        if tags.count > 1000 {
            throw ValidationError.withMessage(ErrorMessage.tagsTooLong)
        }
    }
}
