#if canImport(SwiftUI) && canImport(AppKit)
import AppKit
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
            RootView()
        }
    }
}

#else

import SwiftSyntaxHighlight

@main
struct Main {
    static func main() throws {
        print("This SwiftUI demo app is not supported on your platform.")
    }
}

#endif
