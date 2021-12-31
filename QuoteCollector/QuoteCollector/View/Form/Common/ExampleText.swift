import SwiftUI

struct ExampleText: View {
    var text: String
    var italic: Bool = false

    var body: some View {
        if italic { Text(text).font(.callout).italic() }
        else { Text(text).font(.callout) }
    }
}
