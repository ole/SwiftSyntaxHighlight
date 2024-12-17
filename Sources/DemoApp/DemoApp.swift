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
        struct S {
            var x: Int = 0
        }
        
        var s = S()
        s.x += 1
        """
    @ScaledMetric var fontSize: CGFloat = 20

    var body: some View {
        HSplitView {
            // Left pane
            TextEditor(text: $sourceCode)
                .monospaced()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Right pane
            Text(highlighted)
                .monospaced()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .font(.system(size: fontSize))
    }

    private var highlighted: AttributedString {
        var highlighted = highlight(sourceCode: sourceCode, as: AttributedString.self)
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
    .attribute: .init().foregroundColor(.magenta),
    .blockComment: .init().foregroundColor(.gray),
    .docBlockComment: .init().foregroundColor(.gray),
    .docLineComment: .init().foregroundColor(.gray),
    .dollarIdentifier: .init(),
    .editorPlaceholder: .init(),
    .floatLiteral: .init().foregroundColor(.yellow),
    .identifier: .init().foregroundColor(.blue),
    .ifConfigDirective: .init(),
    .integerLiteral: .init().foregroundColor(.yellow),
    .keyword: .init().foregroundColor(.magenta).inlinePresentationIntent(.stronglyEmphasized),
    .lineComment: .init().foregroundColor(.gray),
    .none: .init(),
    .operator: .init(),
    .regexLiteral: .init().foregroundColor(.purple),
    .stringLiteral: .init().foregroundColor(.red),
    .type: .init().foregroundColor(.green),
    .argumentLabel: .init(),
]
