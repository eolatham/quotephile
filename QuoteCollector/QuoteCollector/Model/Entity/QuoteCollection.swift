import CoreData

@objc(QuoteCollection)
class QuoteCollection: NSManagedObject {
    @objc var exists: Bool { title != nil }
    @objc var titleFirstCharacterAscending: String {
        title!.first!.uppercased()
    }
    @objc var titleFirstCharacterDescending: String {
        // Add space to avoid crash upon switching sort mode
        title!.first!.uppercased() + " "
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
