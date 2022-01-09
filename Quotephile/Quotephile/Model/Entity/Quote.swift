import CoreData

@objc(Quote)
class Quote: NSManagedObject {
    @objc var exists: Bool { text != nil }
    @objc var length: Int { text!.count }
    @objc var rawText: String { text! }
    @objc var exportText: String { "\(rawText) ——\(attribution)" }
    @objc var displayText: String {
        var s: String = rawText
        if displayQuotationMarks { s = "“" + s + "”" }
        if displayAttribution {
            s = s + (displayAttributionOnNewLine ? "\n" : " ") + "—" + attribution
        }
        return s
    }
    @objc var attribution: String {
        var authorName = [authorFirstName!, authorLastName!]
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)
        if authorName.isEmpty { authorName = "Anonymous" }
        if work!.isEmpty { return authorName }
        else { return "\(authorName), \(work!)" }
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
