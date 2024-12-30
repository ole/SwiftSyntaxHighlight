#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif
import SwiftIDEUtils
import SwiftSyntaxHighlight
import Testing

#if canImport(AppKit)
import AppKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(UIKit)
import UIKit
#endif

struct Model: Codable {
    @CodableConfiguration(from: \.swiftSyntax) var string: AttributedString = AttributedString()

    init(string: AttributedString) {
        self.string = string
    }
}

@Suite struct AttributedStringCodableTests {
    @Test func encode() throws {
        let source = """
            42
            """
        let highlighted = highlight(sourceCode: source, as: AttributedString.self)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let json = try encoder.encode(highlighted, configuration: AttributeScopes.SwiftSyntaxAttributes.self)
        #expect(
            String(decoding: json, as: UTF8.self) ==
            """
            [
              "42",
              {
                "SwiftSyntax.SyntaxClassification" : "integerLiteral"
              }
            ]
            """
        )
    }

    @Test func encodeAndDecode() throws {
        let source = """
            struct S {
                var x: Int = 0
            }
            
            var s = S()
            // Add one
            s.x += 1
            """
        let highlighted = highlight(sourceCode: source, as: AttributedString.self)
        let json = try JSONEncoder().encode(
            highlighted,
            configuration: AttributeScopes.SwiftSyntaxAttributes.self
        )
        let decoded = try JSONDecoder().decode(
            AttributedString.self,
            from: json,
            configuration: AttributeScopes.SwiftSyntaxAttributes.self
        )
        #expect(decoded == highlighted)
    }

    @Test func encodeTogetherWithBuiltInAttributes() throws {
        // Given
        let source = """
            "Hello world"
            """
        var highlighted = highlight(sourceCode: source, as: AttributedString.self)
        var frameworkAttributes = AttributeContainer()
        frameworkAttributes.foundation.inlinePresentationIntent = .stronglyEmphasized
        frameworkAttributes.accessibility.accessibilityHeadingLevel = .h3
        #if canImport(AppKit)
        frameworkAttributes.appKit.strokeWidth = 2
        #endif
        #if canImport(SwiftUI)
        frameworkAttributes.swiftUI.baselineOffset = 10
        #endif
        #if canImport(UIKit)
        frameworkAttributes.uiKit.kern = 5
        #endif
        highlighted.mergeAttributes(frameworkAttributes)

        // When
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let json = try encoder.encode(highlighted, configuration: AttributeScopes.SwiftSyntaxAttributes.self)

        // Then
        let expected = AttributedString(
            source,
            attributes: AttributeContainer().syntaxClassification(.stringLiteral).merging(frameworkAttributes)
        )
        let decoded = try JSONDecoder().decode(
            AttributedString.self,
            from: json,
            configuration: AttributeScopes.SwiftSyntaxAttributes.self
        )
        #expect(decoded == expected)
    }
}
