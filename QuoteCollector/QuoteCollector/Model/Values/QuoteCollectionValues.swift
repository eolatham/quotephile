class QuoteCollectionValues: Values {
    var title: String
    var subtitle: String

    init(title: String, subtitle: String = "") {
        self.title = title
        self.subtitle = subtitle
    }

    func formatAndValidate() throws {
        // Format
        title = Utility.trimWhitespace(string: title)
        subtitle = Utility.trimWhitespace(string: subtitle)
        // Validate
        if title.isEmpty {
            throw ValidationError.withMessage(ErrorMessage.titleEmpty)
        }
    }
}
