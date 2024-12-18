import AppKit
import SwiftSyntaxHighlight
import SwiftUI

@MainActor
struct SourceEditor: NSViewRepresentable {
    typealias NSViewType = NSTextView

    @Binding var text: String
    var fontSize: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        textView.delegate = context.coordinator
        context.coordinator.textView = textView
        return textView
    }

    func updateNSView(_ textView: NSTextView, context: Context) {
        context.coordinator.parent = self
        if textView.string != text {
            textView.string = text
        }

        // Apply syntax highlighting
        if let textStorage = textView.textContentStorage?.attributedString as? NSTextStorage {
            var highlighted = text.highlighted
            // Assigning attrContainer.appKit.font = .monospacedSystemFont(…)
            // raises a Sendable warning for NSFont.
            // Avoid this by going through a NSAttributedString.Keys dictionary.
            let defaultAttributes = AttributeContainer([
                NSAttributedString.Key.font: NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular),
                NSAttributedString.Key.foregroundColor: NSColor.textColor,
            ])
            highlighted.mergeAttributes(defaultAttributes, mergePolicy: .keepCurrent)
            let ns = NSAttributedString(highlighted)
            // We know that `textView.string` and `highlighted` contain the same string.
            // So we can iterate over one and apply the ranges to the other one.
            ns.enumerateAttributes(
                in: NSRange(location: 0, length: ns.length),
                options: .longestEffectiveRangeNotRequired
            ) { attributes, range, stop in
                textStorage.setAttributes(attributes, range: range)
            }
        }
    }
}

extension SourceEditor {
    final class Coordinator: NSObject, NSTextViewDelegate {
        var parent: SourceEditor
        var textView: NSTextView!

        init(parent: SourceEditor) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            if textView.string != parent.text {
                parent.text = textView.string
            }
        }
    }
}
