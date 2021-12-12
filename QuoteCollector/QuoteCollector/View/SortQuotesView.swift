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

struct SortQuotesView_Previews: PreviewProvider {
    @State static var sort = QuoteSort.default
    static var previews: some View {
        SortQuotesView(
            selectedSort: $sort,
            sorts: QuoteSort.sorts
        )
    }
}
