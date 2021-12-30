import CoreData

@objc(QuoteCollection)
class QuoteCollection: NSManagedObject {
    @objc var exists: Bool { name != nil }
    @objc var nameFirstCharacterAscending: String {
        name!.first!.uppercased()
    }
    @objc var nameFirstCharacterDescending: String {
        // Add space to avoid crash upon switching sort mode
        name!.first!.uppercased() + " "
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
