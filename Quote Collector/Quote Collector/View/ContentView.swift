import SwiftUI

struct ContentView: View {
    var body: some View {
        QuoteCollectionsView()
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
