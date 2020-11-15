import Foundation
import SwiftUI

#if !os(macOS)
import UIKit
#endif

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

        #if !os(macOS)
        UITextView.appearance().backgroundColor = .clear
        #endif
    }

    var body: some View {
        ZStack {
            TextEditor(text: $text)
                .font(font)
                .background(.clear)
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
