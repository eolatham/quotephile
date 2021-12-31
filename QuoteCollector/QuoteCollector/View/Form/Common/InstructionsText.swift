import SwiftUI

struct InstructionsText: View {
    var text: String

    var body: some View {
        Text(text).font(.callout).bold()
    }
}
