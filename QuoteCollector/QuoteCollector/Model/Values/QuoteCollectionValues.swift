/**
 * A class encapsulating user-editable quote collection values
 * and methods for formatting and validating them.
 */
class QuoteCollectionValues: Values {
    var name: String

    init(name: String) {
        self.name = name
    }

    /**
     * Formats all attributes that require formatting.
     * To be used when saving a quote collection.
     */
    func format() {
        name = QuoteCollectionValues.formatName(name: name)
    }

    /**
     * Validates all attributes that require validation.
     * To be used when saving a quote collection.
     */
    func validate() throws {
        try QuoteCollectionValues.validateName(name: name)
    }

    /**
     * Trims leading and trailing whitespace from the given string.
     */
    static func formatName(name: String) -> String {
        return Utility.trimWhitespace(string: name)
    }

    /**
     * Validates the length of the given name string.
     */
    static func validateName(name: String) throws {
        if name.count < 1 {
            throw ValidationError.withMessage(ErrorMessage.nameEmpty)
        }
        else if name.count > 1000 {
            throw ValidationError.withMessage(ErrorMessage.nameTooLong)
        }
    }
}
