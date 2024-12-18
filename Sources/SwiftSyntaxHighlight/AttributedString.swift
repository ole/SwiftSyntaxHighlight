public import Foundation
public import SwiftIDEUtils
public import SwiftSyntax
#if canImport(AppKit)
public import AppKit
#endif
#if canImport(SwiftUI)
public import SwiftUI
#endif
#if canImport(UIKit)
public import UIKit
#endif


extension AttributedString: OutputFormat {
    public typealias Output = Self

    public static func highlight(sourceCode: SourceFileSyntax) -> AttributedString {
        let sourceBytes = sourceCode.syntaxTextBytes
        var output = AttributedString()
        for segment in sourceCode.classifications {
            let sourceByteRange = segment.range.offset..<segment.range.endOffset
            let attrString = AttributedString(
                String(decoding: sourceBytes[sourceByteRange], as: UTF8.self),
                attributes: AttributeContainer().syntaxClassification(segment.kind)
            )
            output.append(attrString)
        }
        return output
    }
}

extension AttributeScopes {
    public var swiftSyntax: AttributeScopes.SwiftSyntaxAttributes.Type {
        AttributeScopes.SwiftSyntaxAttributes.self
    }
}

extension AttributeScopes {
    public struct SwiftSyntaxAttributes: AttributeScope {
        public let syntaxClassification: SyntaxClassificationAttribute

        // Include the built-in attribute scopes so that all attributes get encoded/decoded
        // when using `AttributeScopes.SwiftSyntaxAttributes.self` as the `CodableConfiguration`.
        public let accessibility: AttributeScopes.AccessibilityAttributes
        public let foundation: AttributeScopes.FoundationAttributes
        #if canImport(AppKit)
        public let appKit: AttributeScopes.AppKitAttributes
        #endif
        #if canImport(SwiftUI)
        public let swiftUI: AttributeScopes.SwiftUIAttributes
        #endif
        #if canImport(UIKit)
        public let uiKit: AttributeScopes.UIKitAttributes
        #endif

        public enum SyntaxClassificationAttribute: AttributedStringKey,
            CodableAttributedStringKey
        {
            public typealias Value = SyntaxClassification
            public static let name: String = "SwiftSyntax.SyntaxClassification"
            public static var inheritedByAddedText: Bool { false }

            public static func encode(_ value: Self.Value, to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(value.codableRepresentation)
            }

            public static func decode(from decoder: any Decoder) throws -> SyntaxClassification {
                let container = try decoder.singleValueContainer()
                let stringValue = try container.decode(String.self)
                guard let value = SyntaxClassification(codableRepresentation: stringValue) else {
                    let context = DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Unknown SyntaxClassification: \(stringValue)"
                    )
                    throw DecodingError.dataCorrupted(context)
                }
                return value
            }
        }
    }
}

extension AttributeDynamicLookup {
    public subscript<T: AttributedStringKey>(
        dynamicMember keyPath: KeyPath<AttributeScopes.SwiftSyntaxAttributes, T>
    ) -> T {
        return self[T.self]
    }
}

extension SyntaxClassification {
    init?(codableRepresentation stringValue: String) {
        switch stringValue {
        case "attribute": self = .attribute
        case "blockComment": self = .blockComment
        case "docBlockComment": self = .docBlockComment
        case "docLineComment": self = .docLineComment
        case "dollarIdentifier": self = .dollarIdentifier
        case "editorPlaceholder": self = .editorPlaceholder
        case "floatLiteral": self = .floatLiteral
        case "identifier": self = .identifier
        case "ifConfigDirective": self = .ifConfigDirective
        case "integerLiteral": self = .integerLiteral
        case "keyword": self = .keyword
        case "lineComment": self = .lineComment
        case "none": self = .none
        case "operator": self = .operator
        case "regexLiteral": self = .regexLiteral
        case "stringLiteral": self = .stringLiteral
        case "type": self = .type
        case "argumentLabel": self = .argumentLabel
        default: return nil
        }

    }

    var codableRepresentation: String {
        switch self {
        case .attribute: "attribute"
        case .blockComment: "blockComment"
        case .docBlockComment: "docBlockComment"
        case .docLineComment: "docLineComment"
        case .dollarIdentifier: "dollarIdentifier"
        case .editorPlaceholder: "editorPlaceholder"
        case .floatLiteral: "floatLiteral"
        case .identifier: "identifier"
        case .ifConfigDirective: "ifConfigDirective"
        case .integerLiteral: "integerLiteral"
        case .keyword: "keyword"
        case .lineComment: "lineComment"
        case .none: "none"
        case .operator: "operator"
        case .regexLiteral: "regexLiteral"
        case .stringLiteral: "stringLiteral"
        case .type: "type"
        case .argumentLabel: "argumentLabel"
        }
    }
}
