import SwiftUI

@main
struct QuotephileApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceManager.shared.container.viewContext)
        }
    }
}
