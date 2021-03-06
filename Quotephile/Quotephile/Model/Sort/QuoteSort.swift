import Foundation

/**
 * Adapted from [this article](https://www.raywenderlich.com/27201015-dynamic-core-data-with-swiftui-tutorial-for-ios).
 */
struct QuoteSort {
    static let sorts: [Sort<Quote>] = [
        Sort<Quote>(
            id: 0,
            name: "Tags ↑",
            descriptors: [
                SortDescriptor(\Quote.tags, order: .forward),
                SortDescriptor(\Quote.dateCreated, order: .reverse)
            ],
            section: \Quote.tagsAscending
        ),
        Sort<Quote>(
            id: 1,
            name: "Tags ↓",
            descriptors: [
                SortDescriptor(\Quote.tags, order: .reverse),
                SortDescriptor(\Quote.dateCreated, order: .reverse)
            ],
            section: \Quote.tagsDescending
        ),
        Sort<Quote>(
            id: 2,
            name: "Author First Name ↑",
            descriptors: [
                SortDescriptor(\Quote.authorFirstName, order: .forward),
                SortDescriptor(\Quote.dateCreated, order: .reverse)
            ],
            section: \Quote.authorFirstNameAscending
        ),
        Sort<Quote>(
            id: 3,
            name: "Author First Name ↓",
            descriptors: [
                SortDescriptor(\Quote.authorFirstName, order: .reverse),
                SortDescriptor(\Quote.dateCreated, order: .reverse)
            ],
            section: \Quote.authorFirstNameDescending
        ),
        Sort<Quote>(
            id: 4,
            name: "Author Last Name ↑",
            descriptors: [
                SortDescriptor(\Quote.authorLastName, order: .forward),
                SortDescriptor(\Quote.dateCreated, order: .reverse)
            ],
            section: \Quote.authorLastNameAscending
        ),
        Sort<Quote>(
            id: 5,
            name: "Author Last Name ↓",
            descriptors: [
                SortDescriptor(\Quote.authorLastName, order: .reverse),
                SortDescriptor(\Quote.dateCreated, order: .reverse)
            ],
            section: \Quote.authorLastNameDescending
        ),
        Sort<Quote>(
            id: 6,
            name: "Work ↑",
            descriptors: [
                SortDescriptor(\Quote.work, order: .forward),
                SortDescriptor(\Quote.dateCreated, order: .reverse)
            ],
            section: \Quote.workAscending
        ),
        Sort<Quote>(
            id: 7,
            name: "Work ↓",
            descriptors: [
                SortDescriptor(\Quote.work, order: .reverse),
                SortDescriptor(\Quote.dateCreated, order: .reverse)
            ],
            section: \Quote.workDescending
        ),
        Sort<Quote>(
            id: 8,
            name: "Date Created ↑",
            descriptors: [SortDescriptor(\Quote.dateCreated, order: .forward)],
            section: \Quote.monthCreatedAscending
        ),
        Sort<Quote>(
            id: 9,
            name: "Date Created ↓",
            descriptors: [SortDescriptor(\Quote.dateCreated, order: .reverse)],
            section: \Quote.monthCreatedDescending
        ),
        Sort<Quote>(
            id: 10,
            name: "Date Changed ↑",
            descriptors: [SortDescriptor(\Quote.dateChanged, order: .forward)],
            section: \Quote.monthChangedAscending
        ),
        Sort<Quote>(
            id: 11,
            name: "Date Changed ↓",
            descriptors: [SortDescriptor(\Quote.dateChanged, order: .reverse)],
            section: \Quote.monthChangedDescending
        )
    ]
    static var `default`: Sort<Quote> { sorts[9] }

    /**
     * Helper for the user default methods.
     */
    private static func withId(id: Int) -> Sort<Quote>? {
        var sortWithId: Sort<Quote>? = nil
        for sort in sorts {
            if sort.id == id {
                sortWithId = sort
                break
            }
        }
        return sortWithId
    }

    /**
     * Helper for the user default methods.
     */
    private static func userDefaultKey(
        quoteCollection: QuoteCollection? = nil
    ) -> String {
        return quoteCollection == nil
            ? "allQuotesSortId"
            : "quoteCollectionSortId-\(quoteCollection!.id!)"
    }

    /**
     * Gets the persisted user default quote sort (or the static default if no user default exists)
     * for the given quote collection (or the "All Quotes" collection if no quote collection is given).
     */
    static func getUserDefault(
        quoteCollection: QuoteCollection? = nil
    ) -> Sort<Quote> {
        var sort: Sort<Quote>? = nil
        let key = userDefaultKey(quoteCollection: quoteCollection)
        let id: Int? = UserDefaults.standard.object(forKey: key) as? Int
        if id != nil { sort = QuoteSort.withId(id: id!) }
        return sort ?? QuoteSort.default
    }

    /**
     * Persists the given sort as the user default quote sort for the given quote
     * collection (or the "All Quotes" collection if no quote collection is given).
     */
    static func setUserDefault(
        sort: Sort<Quote>,
        quoteCollection: QuoteCollection? = nil
    ) {
        let key = userDefaultKey(quoteCollection: quoteCollection)
        UserDefaults.standard.set(sort.id, forKey: key)
    }

    /**
     * Deletes the persisted user default quote sort for the given quote collection.
     */
    static func deleteUserDefault(quoteCollection: QuoteCollection) {
        let key = userDefaultKey(quoteCollection: quoteCollection)
        UserDefaults.standard.removeObject(forKey: key)
    }
}
