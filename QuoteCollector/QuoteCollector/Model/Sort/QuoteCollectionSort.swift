import Foundation

struct QuoteCollectionSort {
    static let sorts: [Sort<QuoteCollection>] = [
        Sort<QuoteCollection>(
            id: 0,
            name: "Name ↑",
            descriptors: [SortDescriptor(\QuoteCollection.name, order: .forward)],
            section: \QuoteCollection.nameFirstCharacterAscending
        ),
        Sort<QuoteCollection>(
            id: 1,
            name: "Name ↓",
            descriptors: [SortDescriptor(\QuoteCollection.name, order: .reverse)],
            section: \QuoteCollection.nameFirstCharacterDescending
        ),
        Sort<QuoteCollection>(
            id: 2,
            name: "Date Created ↑",
            descriptors: [
                SortDescriptor(\QuoteCollection.dateCreated, order: .forward),
                SortDescriptor(\QuoteCollection.name, order: .forward)
            ],
            section: \QuoteCollection.monthCreatedAscending
        ),
        Sort<QuoteCollection>(
            id: 3,
            name: "Date Created ↓",
            descriptors: [
                SortDescriptor(\QuoteCollection.dateCreated, order: .reverse),
                SortDescriptor(\QuoteCollection.name, order: .forward)
            ],
            section: \QuoteCollection.monthCreatedDescending
        ),
        Sort<QuoteCollection>(
            id: 4,
            name: "Date Changed ↑",
            descriptors: [
                SortDescriptor(\QuoteCollection.dateChanged, order: .forward),
                SortDescriptor(\QuoteCollection.name, order: .forward)
            ],
            section: \QuoteCollection.monthChangedAscending
        ),
        Sort<QuoteCollection>(
            id: 5,
            name: "Date Changed ↓",
            descriptors: [
                SortDescriptor(\QuoteCollection.dateChanged, order: .reverse),
                SortDescriptor(\QuoteCollection.name, order: .forward)
            ],
            section: \QuoteCollection.monthChangedDescending
        )
    ]
    static var `default`: Sort<QuoteCollection> { sorts[3] }

    static func withId(id: Int) -> Sort<QuoteCollection>? {
        var sortWithId: Sort<QuoteCollection>? = nil
        for sort in sorts {
            if sort.id == id {
                sortWithId = sort
                break
            }
        }
        return sortWithId
    }

    /**
     * Gets the persisted user default quote collection sort
     * (or the static default if no user default exists).
     */
    static func getUserDefault() -> Sort<QuoteCollection> {
        var sort: Sort<QuoteCollection>? = nil
        let id: Int? = UserDefaults.standard.object(forKey: "quoteCollectionsSortId") as? Int
        if id != nil { sort = QuoteCollectionSort.withId(id: id!) }
        return sort ?? QuoteCollectionSort.default
    }

    /**
     * Persists the given sort as the user default quote collection sort.
     */
    static func setUserDefault(sort: Sort<QuoteCollection>) {
        UserDefaults.standard.set(sort.id, forKey: "quoteCollectionsSortId")
    }
}
