import CoreData

@objc(Quote)
class Quote: NSManagedObject {
    @objc var exists: Bool { text != nil }
    @objc var length: Int { text!.count }
    @objc var rawText: String { text! }
    @objc var displayText: String {
        var s: String = text!
        if displayQuotationMarks { s = "“" + s + "”" }
        if displayAuthor {
            s = s + (displayAuthorOnNewLine ? "\n" : " ") + "—" + author
        }
        return s
    }
    @objc var author: String {
        let name = [authorFirstName!, authorLastName!]
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)
        if name.isEmpty { return "Anonymous" }
        return name
    }
    @objc var authorFirstNameAscending: String {
        authorFirstName!.isEmpty ? "ANONYMOUS" : authorFirstName!.uppercased()
    }
    @objc var authorFirstNameDescending: String {
        // Add space to avoid crash upon switching sort mode
        (authorFirstName!.isEmpty ? "ANONYMOUS" : authorFirstName!.uppercased()) + " "
    }
    @objc var authorLastNameAscending: String {
        authorLastName!.isEmpty ? "ANONYMOUS" : authorLastName!.uppercased()
    }
    @objc var authorLastNameDescending: String {
        // Add space to avoid crash upon switching sort mode
        (authorLastName!.isEmpty ? "ANONYMOUS" : authorLastName!.uppercased()) + " "
    }
    @objc var tagsAscending: String {
        tags!.isEmpty ? "NONE" : tags!.uppercased()
    }
    @objc var tagsDescending: String {
        // Add space to avoid crash upon switching sort mode
        (tags!.isEmpty ? "NONE" : tags!.uppercased()) + " "
    }
    @objc var monthCreatedAscending: String {
        Utility.dateToMonthString(date:dateCreated!)
    }
    @objc var monthCreatedDescending: String {
        // Add space to avoid crash upon switching sort mode
        Utility.dateToMonthString(date:dateCreated!) + " "
    }
    @objc var monthChangedAscending: String {
        Utility.dateToMonthString(date:dateChanged!)
    }
    @objc var monthChangedDescending: String {
        // Add space to avoid crash upon switching sort mode
        Utility.dateToMonthString(date:dateChanged!) + " "
    }

    /**
     * Trims leading and trailing whitespace from the given string.
     * To be used when saving a quote.
     */
    static func formatText(text: String) -> String {
        return Utility.trimWhitespace(string: text)
    }

    /**
     * Trims leading and trailing whitespace from the given string.
     * To be used when saving a quote.
     */
    static func formatAuthor(author: String) -> String {
        return Utility.trimWhitespace(string: author)
    }

    /**
     * Transforms the given comma-separated list of tags into
     * a set of unique, nonempty, and capitalized tags.
     * To be used when saving a quote.
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
     * To be used when saving a quote.
     */
    static func formattedSetOfTagsToString(tags: Set<String>) -> String {
        return tags.sorted().joined(separator: ", ")
    }

    /**
     * Transforms the given unformatted comma-separated list of tags into a comma-separated
     * and alphabetically-sorted list of unique, nonempty, and capitalized tags.
     * To be used when saving a quote.
     */
    static func formatTags(tags: String) -> String {
        return formattedSetOfTagsToString(
            tags: tagsStringToFormattedSet(tags: tags)
        )
    }
}
