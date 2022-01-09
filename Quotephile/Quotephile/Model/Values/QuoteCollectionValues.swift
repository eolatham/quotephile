class QuoteCollectionValues: Values {
    var name: String

    init(name: String) {
        self.name = name
    }

    func equals(quoteCollection: QuoteCollection) -> Bool {
        return name == quoteCollection.name!
    }

    func formatAndValidate() throws {
        // Format
        name = QuoteCollectionValues.formatName(name: name)
        // Validate
        if name.isEmpty {
            throw ValidationError.withMessage(ErrorMessage.nameEmpty)
        }
    }

    /**
     * Trims leading and trailing whitespace from the given string.
     */
    static func formatName(name: String) -> String {
        return Utility.cleanWhitespace(string: name)
    }
}
