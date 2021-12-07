//
//  ContentView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/6/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        QuoteCollectionListView(quoteCollections: quoteCollections)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
