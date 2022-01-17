import SwiftUI
import CoreData

@main
struct QuotephileApp: App {
    var viewContext: NSManagedObjectContext {
        let context = PersistenceManager.shared.container.viewContext
        DatabaseFunctions.ensureCorrectAuthorFullNameValues(context: context)
        return context
    }

    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, viewContext)
        }
    }
}
