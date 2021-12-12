//
//  SelectSortView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import SwiftUI

struct SortQuoteCollectionsView: View {
    @Binding var selectedSort: QuoteCollectionSort

    let sorts: [QuoteCollectionSort]
    
    var body: some View {
        Menu {
            Picker("Sort By", selection: $selectedSort) {
                ForEach(sorts, id: \.self) { sort in
                    Text("\(sort.name)")
                }
            }
        } label: {
            Label(
                "Sort",
                systemImage: "line.horizontal.3.decrease.circle"
            )
        }
        .pickerStyle(.inline)
    }
}

struct SortQuoteCollectionsView_Previews: PreviewProvider {
  @State static var sort = QuoteCollectionSort.default
    static var previews: some View {
        SortQuoteCollectionsView(
            selectedSort: $sort,
            sorts: QuoteCollectionSort.sorts
        ).environment(
            \.managedObjectContext,
            PersistenceManager.preview.container.viewContext
        )
    }
}
