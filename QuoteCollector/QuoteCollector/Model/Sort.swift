//
//  Sort.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/26/21.
//

import Foundation

struct Sort<E>: Hashable, Identifiable {
    let id: Int
    let name: String
    let descriptors: [SortDescriptor<E>]
    let section: KeyPath<E, String>
}

