import SwiftUI

struct CancelButtonView: View {
    var dismiss: DismissAction

    var body: some View {
        Button("Cancel") { dismiss() }
    }
}
