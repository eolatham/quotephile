//
//  QuoteCollectionSort.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

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
}
