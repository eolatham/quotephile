//
//  QuoteSort.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import Foundation

struct QuoteSort: Hashable, Identifiable {
  let id: Int
  let name: String
  let descriptors: [SortDescriptor<Quote>]
  let section: KeyPath<Quote, String>

  static let sorts: [QuoteSort] = [
    QuoteSort(
        id: 0,
        name: "Author ↑",
        descriptors: [SortDescriptor(\Quote.author, order: .forward)],
        section: \Quote.authorAscending
    ),
    QuoteSort(
        id: 1,
        name: "Author ↓",
        descriptors: [SortDescriptor(\Quote.author, order: .reverse)],
        section: \Quote.authorDescending
    ),
    QuoteSort(
        id: 2,
        name: "Date Created ↑",
        descriptors: [SortDescriptor(\Quote.dateCreated, order: .forward)],
        section: \Quote.dayCreatedAscending
    ),
    QuoteSort(
        id: 3,
        name: "Date Created ↓",
        descriptors: [SortDescriptor(\Quote.dateCreated, order: .reverse)],
        section: \Quote.dayCreatedDescending
    ),
    QuoteSort(
        id: 4,
        name: "Date Changed ↑",
        descriptors: [SortDescriptor(\Quote.dateChanged, order: .forward)],
        section: \Quote.dayChangedAscending
    ),
    QuoteSort(
        id: 5,
        name: "Date Changed ↓",
        descriptors: [SortDescriptor(\Quote.dateChanged, order: .reverse)],
        section: \Quote.dayChangedDescending
    )
  ]

  static var `default`: QuoteSort { sorts[3] }
}
