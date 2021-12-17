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
        name: "Author First Name ↑",
        descriptors: [SortDescriptor(\Quote.authorFirstName, order: .forward)],
        section: \Quote.authorFirstNameAscending
    ),
    QuoteSort(
        id: 1,
        name: "Author First Name ↓",
        descriptors: [SortDescriptor(\Quote.authorFirstName, order: .reverse)],
        section: \Quote.authorFirstNameDescending
    ),
    QuoteSort(
        id: 2,
        name: "Author Last Name ↑",
        descriptors: [SortDescriptor(\Quote.authorLastName, order: .forward)],
        section: \Quote.authorLastNameAscending
    ),
    QuoteSort(
        id: 3,
        name: "Author Last Name ↓",
        descriptors: [SortDescriptor(\Quote.authorLastName, order: .reverse)],
        section: \Quote.authorLastNameDescending
    ),
    QuoteSort(
        id: 4,
        name: "Date Created ↑",
        descriptors: [SortDescriptor(\Quote.dateCreated, order: .forward)],
        section: \Quote.monthCreatedAscending
    ),
    QuoteSort(
        id: 5,
        name: "Date Created ↓",
        descriptors: [SortDescriptor(\Quote.dateCreated, order: .reverse)],
        section: \Quote.monthCreatedDescending
    ),
    QuoteSort(
        id: 6,
        name: "Date Changed ↑",
        descriptors: [SortDescriptor(\Quote.dateChanged, order: .forward)],
        section: \Quote.monthChangedAscending
    ),
    QuoteSort(
        id: 7,
        name: "Date Changed ↓",
        descriptors: [SortDescriptor(\Quote.dateChanged, order: .reverse)],
        section: \Quote.monthChangedDescending
    )
  ]

  static var `default`: QuoteSort { sorts[5] }
}
