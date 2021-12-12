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
                    Text(sort.name)
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down.circle")
        }
        .pickerStyle(.inline)
    }
}
