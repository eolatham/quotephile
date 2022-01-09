import CoreData

struct CodableQuoteCollection: Codable {
    let id: UUID
    let dateCreated: Date
    let dateChanged: Date
    let name: String
    let quotes: [CodableQuote]
}

@objc(QuoteCollection)
class QuoteCollection: NSManagedObject {
    func toCodable() -> CodableQuoteCollection {
        let codableQuotes: [CodableQuote] = quotes!.map({ quote in
            (quote as! Quote).toCodable()
        })
        return CodableQuoteCollection(
            id: id!,
            dateCreated: dateCreated!,
            dateChanged: dateChanged!,
            name: name!,
            quotes: codableQuotes
        )
    }

    static func fromCodable(
        context: NSManagedObjectContext,
        codable: CodableQuoteCollection
    ) -> QuoteCollection {
        let quoteCollection = QuoteCollection(context: context)
        quoteCollection.id = codable.id
        quoteCollection.dateCreated = codable.dateCreated
        quoteCollection.dateChanged = codable.dateChanged
        quoteCollection.name = codable.name
        quoteCollection.quotes = NSSet(array: codable.quotes.map({ c in
            Quote.fromCodable(context: context, codable: c)
        }))
        return quoteCollection
    }

    @objc var exists: Bool { name != nil }
    @objc var nameFirstCharacterAscending: String {
        name!.first!.uppercased()
    }
    @objc var nameFirstCharacterDescending: String {
        // Add space to avoid crash upon switching sort mode
        nameFirstCharacterAscending + " "
    }
    @objc var monthCreatedAscending: String {
        Utility.dateToMonthString(date:dateCreated!)
    }
    @objc var monthCreatedDescending: String {
        // Add space to avoid crash upon switching sort mode
        monthCreatedAscending + " "
    }
    @objc var monthChangedAscending: String {
        Utility.dateToMonthString(date:dateChanged!)
    }
    @objc var monthChangedDescending: String {
        // Add space to avoid crash upon switching sort mode
        monthChangedAscending + " "
    }
}
