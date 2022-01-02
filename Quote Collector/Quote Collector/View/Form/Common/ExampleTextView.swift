import SwiftUI

struct ExampleTextView: View {
    var text: String
    var small: Bool = false
    var italic: Bool = false

    var body: some View {
        if italic {
            Text(text)
            .font(small ? .caption : .callout)
            .italic()
        } else {
            Text(text)
            .font(small ? .caption : .callout)
        }
    }
}
