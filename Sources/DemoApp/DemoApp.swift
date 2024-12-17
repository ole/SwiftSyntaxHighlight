import Foundation
import SwiftSyntaxHighlight
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
        highlighted.replaceAttributes(
            AttributeContainer().syntaxClassification(.keyword),
            with: AttributeContainer().foregroundColor(.magenta).inlinePresentationIntent(.stronglyEmphasized)
        )
        return highlighted
    }
}
