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
        // FIXME: Syntax highlighting doesn't update when the user edits the text in the NSTextView.
        // The cause is that this condition is too strict. We still have to rehighlight the text
        // in some cases even if the text contents are unchanged at this point.
        if textView.string != text {
            var highlighted = text.highlighted
            // someAttributeContainer.appKit.font = .monospacedSystemFont(ofSize: fontSize, weight: .regular)
            // raises a Sendable warning for NSFont.
            // Avoid this by going via the dictionary of NSAttributedString.Keys initializer.
            let defaultAttributes = AttributeContainer([
                NSAttributedString.Key.font: NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular),
                NSAttributedString.Key.foregroundColor: NSColor.textColor,
            ])
            highlighted.mergeAttributes(defaultAttributes, mergePolicy: .keepCurrent)
            // Modify the NSTextView's text storage instead of replacing it with a new object.
            // Assigning a new NSTextStorage object to textView.textContentStorage?.attributedString
            // makes the text view non-editable.
            if let textStorage = textView.textContentStorage?.attributedString as? NSTextStorage {
                textStorage.replaceCharacters(
                    in: NSRange(location: 0, length: textStorage.length),
                    with: NSTextStorage(highlighted)
                )
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
