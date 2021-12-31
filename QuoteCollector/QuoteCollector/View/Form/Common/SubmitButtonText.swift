import SwiftUI

struct SubmitButtonText: View {
    var text: String = "Save"

    var body: some View {
        Text(text).font(.headline).foregroundColor(.accentColor)
    }
}
