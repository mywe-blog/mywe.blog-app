import Foundation
import SwiftUI

struct MultilineTextEditor: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        ZStack {
            TextEditor(text: $text)
            if text.isEmpty {
                HStack {
                    Text(placeholder)
                        .opacity(0.2)
                        .padding(.all, 8)
                    Spacer()
                }
                .allowsHitTesting(false)
            } else {
                Text(text).opacity(0).padding(.all, 8)
            }
        }
    }
}
