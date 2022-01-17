import CoreData

struct CodableQuote: Codable {
    let id: UUID
    let dateCreated: Date
    let dateChanged: Date
    let text: String
    let authorFirstName: String
    let authorLastName: String
    let work: String
    let tags: String
    let displayQuotationMarks: Bool
    let displayAuthor: Bool
    let displayWork: Bool
    let displayAuthorAndWorkOnNewLine: Bool
}

@objc(Quote)
class Quote: NSManagedObject {
    func toCodable() -> CodableQuote {
        return CodableQuote(
            id: id!,
            dateCreated: dateCreated!,
            dateChanged: dateChanged!,
            text: text!,
            authorFirstName: authorFirstName!,
            authorLastName: authorLastName!,
            work: work!,
            tags: tags!,
            displayQuotationMarks: displayQuotationMarks,
            displayAuthor: displayAuthor,
            displayWork: displayWork,
            displayAuthorAndWorkOnNewLine: displayAuthorAndWorkOnNewLine
        )
    }

    static func fromCodable(
        context: NSManagedObjectContext,
        codable: CodableQuote
    ) -> Quote {
        let quote = Quote(context: context)
        quote.id = codable.id
        quote.dateCreated = codable.dateCreated
        quote.dateChanged = codable.dateChanged
        quote.text = codable.text
        quote.authorFirstName = codable.authorFirstName
        quote.authorLastName = codable.authorLastName
        quote.work = codable.work
        quote.tags = codable.tags
        quote.displayQuotationMarks = codable.displayQuotationMarks
        quote.displayAuthor = codable.displayAuthor
        quote.displayWork = codable.displayWork
        quote.displayAuthorAndWorkOnNewLine = codable.displayAuthorAndWorkOnNewLine
        return quote
    }

    @objc var exists: Bool { text != nil }
    @objc var length: Int { text!.count }
    @objc var rawText: String { text! }
    @objc var author: String {
        var a = authorFullName!.trimmingCharacters(in: .whitespaces)
        if a.isEmpty { a = "Anonymous" }
        return a
    }
    @objc var authorAndWork: String {
        work!.isEmpty ? author : "\(author), \(work!)"
    }
    @objc var exportText: String { "\(rawText) ——\(authorAndWork)" }
    @objc var displayText: String {
        var s: String = displayQuotationMarks ? "“\(rawText)”" : rawText
        let delimiter: String = displayAuthorAndWorkOnNewLine ? "\n—" : " —"
        if displayAuthor && displayWork {
            s += delimiter + authorAndWork
        } else if displayAuthor {
            s += delimiter + author
        } else if displayWork && !work!.isEmpty {
            s += delimiter + work!
        }
        return s
    }
    @objc var authorFirstNameAscending: String {
        authorFirstName!.isEmpty ? "NONE" : authorFirstName!.uppercased()
    }
    @objc var authorFirstNameDescending: String {
        // Add space to avoid crash upon switching sort mode
        authorFirstNameAscending + " "
    }
    @objc var authorLastNameAscending: String {
        authorLastName!.isEmpty ? "NONE" : authorLastName!.uppercased()
    }
    @objc var authorLastNameDescending: String {
        // Add space to avoid crash upon switching sort mode
        authorLastNameAscending + " "
    }
    @objc var workAscending: String {
        work!.isEmpty ? "NONE" : work!.uppercased()
    }
    @objc var workDescending: String {
        // Add space to avoid crash upon switching sort mode
        workAscending + " "
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
}
