//
//  SortQuotesView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/12/21.
//

import SwiftUI

struct SortQuotesView: View {
    @Binding var selectedSort: QuoteSort

    let sorts: [QuoteSort]
    
    var body: some View {
        Menu {
            Picker("Sort By", selection: $selectedSort) {
                ForEach(sorts, id: \.self) { sort in
                    Text(sort.name)
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
        .pickerStyle(.inline)
    }
}
