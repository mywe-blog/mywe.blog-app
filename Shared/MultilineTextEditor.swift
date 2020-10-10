import Foundation
import SwiftUI

struct MultilineTextEditor: View {
    let placeholder: String
    let font: Font
    @Binding var text: String

    init(placeholder: String,
         font: Font = .body,
         text: Binding<String>) {
        self.placeholder = placeholder
        self.font = font
        self._text = text
    }

    var body: some View {
        ZStack {
            TextEditor(text: $text)
                .font(font)
            if text.isEmpty {
                HStack {
                    Text(placeholder)
                        .opacity(0.2)
                        .padding(.all, 8)
                    Spacer()
                }
            } else {
                Text(text)
                    .font(font)
                    .opacity(0)
                    .padding(.all, 8)
            }
        }
    }
}
