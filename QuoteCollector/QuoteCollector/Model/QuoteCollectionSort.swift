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
        name: "Date Created ↓",
        descriptors: [
            SortDescriptor(\QuoteCollection.dateCreated, order: .reverse),
            SortDescriptor(\QuoteCollection.name, order: .forward)
        ],
        section: \QuoteCollection.dayCreatedDescending),
    QuoteCollectionSort(
        id: 1,
        name: "Date Created ↑",
        descriptors: [
            SortDescriptor(\QuoteCollection.dateCreated, order: .forward),
            SortDescriptor(\QuoteCollection.name, order: .forward)
        ],
        section: \QuoteCollection.dayCreatedAscending),
    QuoteCollectionSort(
        id: 2,
        name: "Date Changed ↓",
        descriptors: [
            SortDescriptor(\QuoteCollection.dateChanged, order: .reverse),
            SortDescriptor(\QuoteCollection.name, order: .forward)
        ],
        section: \QuoteCollection.dayChangedDescending),
    QuoteCollectionSort(
        id: 3,
        name: "Date Changed ↑",
        descriptors: [
            SortDescriptor(\QuoteCollection.dateChanged, order: .forward),
            SortDescriptor(\QuoteCollection.name, order: .forward)
        ],
        section: \QuoteCollection.dayChangedAscending),
    QuoteCollectionSort(
        id: 4,
        name: "Name ↓",
        descriptors: [SortDescriptor(\QuoteCollection.name, order: .reverse)],
        section: \QuoteCollection.nameDescending),
    QuoteCollectionSort(
        id: 5,
        name: "Name ↑",
        descriptors: [SortDescriptor(\QuoteCollection.name, order: .forward)],
        section: \QuoteCollection.nameAscending)
  ]

  static var `default`: QuoteCollectionSort { sorts[0] }
}
