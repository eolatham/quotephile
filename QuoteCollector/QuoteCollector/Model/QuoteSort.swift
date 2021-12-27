import Foundation

struct QuoteSort {
    static let sorts: [Sort<Quote>] = [
        Sort<Quote>(
            id: 0,
            name: "Tags ↑",
            descriptors: [SortDescriptor(\Quote.tags, order: .forward)],
            section: \Quote.tagsAscending
        ),
        Sort<Quote>(
            id: 1,
            name: "Tags ↓",
            descriptors: [SortDescriptor(\Quote.tags, order: .reverse)],
            section: \Quote.tagsDescending
        ),
        Sort<Quote>(
            id: 2,
            name: "Author First Name ↑",
            descriptors: [SortDescriptor(\Quote.authorFirstName, order: .forward)],
            section: \Quote.authorFirstNameAscending
        ),
        Sort<Quote>(
            id: 3,
            name: "Author First Name ↓",
            descriptors: [SortDescriptor(\Quote.authorFirstName, order: .reverse)],
            section: \Quote.authorFirstNameDescending
        ),
        Sort<Quote>(
            id: 4,
            name: "Author Last Name ↑",
            descriptors: [SortDescriptor(\Quote.authorLastName, order: .forward)],
            section: \Quote.authorLastNameAscending
        ),
        Sort<Quote>(
            id: 5,
            name: "Author Last Name ↓",
            descriptors: [SortDescriptor(\Quote.authorLastName, order: .reverse)],
            section: \Quote.authorLastNameDescending
        ),
        Sort<Quote>(
            id: 6,
            name: "Date Created ↑",
            descriptors: [SortDescriptor(\Quote.dateCreated, order: .forward)],
            section: \Quote.monthCreatedAscending
        ),
        Sort<Quote>(
            id: 7,
            name: "Date Created ↓",
            descriptors: [SortDescriptor(\Quote.dateCreated, order: .reverse)],
            section: \Quote.monthCreatedDescending
        ),
        Sort<Quote>(
            id: 8,
            name: "Date Changed ↑",
            descriptors: [SortDescriptor(\Quote.dateChanged, order: .forward)],
            section: \Quote.monthChangedAscending
        ),
        Sort<Quote>(
            id: 9,
            name: "Date Changed ↓",
            descriptors: [SortDescriptor(\Quote.dateChanged, order: .reverse)],
            section: \Quote.monthChangedDescending
        )
    ]
    static var `default`: Sort<Quote> { sorts[7] }
}
