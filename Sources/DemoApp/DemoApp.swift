import Foundation
import SwiftSyntaxHighlight
import SwiftIDEUtils
import SwiftUI

@main
struct SwiftSyntaxHighlightDemo: App {
    init() {
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(.regular)
            NSApp.activate(ignoringOtherApps: true)
            NSApp.windows.first?.makeKeyAndOrderFront(nil)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var sourceCode: String = """
        /// Model type
        struct S {
            var x: Int = 0
        }
        
        var s = S()
        // Add one
        s.x += 1
        """
    @ScaledMetric var fontSize: CGFloat = 20

    var body: some View {
        HSplitView {
            SourceEditor(text: $sourceCode, fontSize: fontSize)

            // Left pane
            TextEditor(text: $sourceCode)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .monospaced()
                .font(.system(size: fontSize))

            // Right pane
            Text(sourceCode.highlighted)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .font(.system(size: fontSize).monospaced())
        }
    }

}

extension String {
    var highlighted: AttributedString {
        var highlighted = highlight(sourceCode: self, as: AttributedString.self)
        for (syntaxKind, attributes) in theme {
            highlighted.replaceAttributes(
                AttributeContainer().syntaxClassification(syntaxKind),
                with: attributes
            )
        }
        return highlighted
    }
}

let theme: [SyntaxClassification: AttributeContainer] = [
    .attribute: { var c = AttributeContainer(); c.swiftUI.foregroundColor = .pink; c.appKit.foregroundColor = .magenta; return c }(),
    .blockComment: { var c = AttributeContainer(); c.swiftUI.foregroundColor = .gray; c.appKit.foregroundColor = .gray; return c }(),
    .docBlockComment: { var c = AttributeContainer(); c.swiftUI.foregroundColor = .gray; c.appKit.foregroundColor = .gray; return c }(),
    .docLineComment: { var c = AttributeContainer(); c.swiftUI.foregroundColor = .gray; c.appKit.foregroundColor = .gray; return c }(),
    .dollarIdentifier: { var c = AttributeContainer(); return c }(),
    .editorPlaceholder: { var c = AttributeContainer(); return c }(),
    .floatLiteral: { var c = AttributeContainer(); c.swiftUI.foregroundColor = .yellow; c.appKit.foregroundColor = .yellow; return c }(),
    .identifier: { var c = AttributeContainer(); c.swiftUI.foregroundColor = .blue; c.appKit.foregroundColor = .blue; return c }(),
    .ifConfigDirective: { var c = AttributeContainer(); return c }(),
    .integerLiteral: { var c = AttributeContainer(); c.swiftUI.foregroundColor = .yellow; c.appKit.foregroundColor = .yellow; return c }(),
    .keyword: { var c = AttributeContainer(); c.swiftUI.foregroundColor = .pink; c.appKit.foregroundColor = .magenta; c.foundation.inlinePresentationIntent = .stronglyEmphasized; return c }(),
    .lineComment: { var c = AttributeContainer(); c.swiftUI.foregroundColor = .gray; c.appKit.foregroundColor = .gray; return c }(),
    .none: { var c = AttributeContainer(); return c }(),
    .operator: { var c = AttributeContainer(); return c }(),
    .regexLiteral: { var c = AttributeContainer(); c.swiftUI.foregroundColor = .purple; c.appKit.foregroundColor = .purple; return c }(),
    .stringLiteral: { var c = AttributeContainer(); c.swiftUI.foregroundColor = .red; c.appKit.foregroundColor = .red; return c }(),
    .type: { var c = AttributeContainer(); c.swiftUI.foregroundColor = .green; c.appKit.foregroundColor = .green; return c }(),
    .argumentLabel: { var c = AttributeContainer(); return c }(),
]