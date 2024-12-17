public import SwiftIDEUtils
public import SwiftSyntax
public import Foundation

extension AttributeScopes {
    public var swiftSyntax: SwiftSyntaxAttributeScope.Type {
        SwiftSyntaxAttributeScope.self
    }
}

public struct SwiftSyntaxAttributeScope: AttributeScope {
    public let syntaxClassification: SyntaxClassificationAttribute

    public enum SyntaxClassificationAttribute: AttributedStringKey {
        public typealias Value = SyntaxClassification
        public static let name: String = "SwiftSyntax.SyntaxClassification"
    }
}

extension AttributeDynamicLookup {
    public subscript<T: AttributedStringKey>(dynamicMember keyPath: KeyPath<SwiftSyntaxAttributeScope, T>) -> T {
        return self[T.self]
    }
}

extension AttributedString: OutputFormat {
    public typealias Output = Self

    public static func highlight(sourceCode: SourceFileSyntax) -> AttributedString {
        let sourceBytes = sourceCode.syntaxTextBytes
        var output = AttributedString()
        for segment in sourceCode.classifications {
            let sourceByteRange = segment.range.offset ..< segment.range.endOffset
            let attrString = AttributedString(
                String(decoding: sourceBytes[sourceByteRange], as: UTF8.self),
                attributes: AttributeContainer().syntaxClassification(segment.kind)
            )
            output.append(attrString)
        }
        return output
    }
}
