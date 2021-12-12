//
//  QuoteCollectionSort.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import Foundation

struct QuoteCollectionSort: Hashable, Identifiable {
  let id: Int
  let name: String
  let descriptors: [SortDescriptor<QuoteCollection>]
  let section: KeyPath<QuoteCollection, String>

  static let sorts: [QuoteCollectionSort] = [
    QuoteCollectionSort(
        id: 0,
        name: "Name ↑",
        descriptors: [SortDescriptor(\QuoteCollection.name, order: .forward)],
        section: \QuoteCollection.nameFirstCharacterAscending
    ),
    QuoteCollectionSort(
        id: 1,
        name: "Name ↓",
        descriptors: [SortDescriptor(\QuoteCollection.name, order: .reverse)],
        section: \QuoteCollection.nameFirstCharacterDescending
    ),
    QuoteCollectionSort(
        id: 2,
        name: "Date Created ↑",
        descriptors: [
            SortDescriptor(\QuoteCollection.dateCreated, order: .forward),
            SortDescriptor(\QuoteCollection.name, order: .forward)
        ],
        section: \QuoteCollection.dayCreatedAscending
    ),
    QuoteCollectionSort(
        id: 3,
        name: "Date Created ↓",
        descriptors: [
            SortDescriptor(\QuoteCollection.dateCreated, order: .reverse),
            SortDescriptor(\QuoteCollection.name, order: .forward)
        ],
        section: \QuoteCollection.dayCreatedDescending
    ),
    QuoteCollectionSort(
        id: 4,
        name: "Date Changed ↑",
        descriptors: [
            SortDescriptor(\QuoteCollection.dateChanged, order: .forward),
            SortDescriptor(\QuoteCollection.name, order: .forward)
        ],
        section: \QuoteCollection.dayChangedAscending
    ),
    QuoteCollectionSort(
        id: 5,
        name: "Date Changed ↓",
        descriptors: [
            SortDescriptor(\QuoteCollection.dateChanged, order: .reverse),
            SortDescriptor(\QuoteCollection.name, order: .forward)
        ],
        section: \QuoteCollection.dayChangedDescending
    )
  ]

  static var `default`: QuoteCollectionSort { sorts[3] }
}
