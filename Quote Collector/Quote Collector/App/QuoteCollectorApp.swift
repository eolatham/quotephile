import SwiftUI

@main
struct QuoteCollectorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceManager.shared.container.viewContext)
        }
    }
}
