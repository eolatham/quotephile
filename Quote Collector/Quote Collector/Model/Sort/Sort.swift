import Foundation

struct Sort<E>: Hashable, Identifiable {
    let id: Int
    let name: String
    let descriptors: [SortDescriptor<E>]
    let section: KeyPath<E, String>
}
