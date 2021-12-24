//
//  ContentView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/7/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        QuoteCollectionListContainerView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environment(
            \.managedObjectContext,
             PersistenceManager.preview.container.viewContext
        )
    }
}
