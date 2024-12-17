import SwiftIDEUtils
public import SwiftSyntax
public import Foundation

extension AttributedString: OutputFormat {
    public typealias Output = Self

    public static func highlight(sourceCode: SourceFileSyntax) -> AttributedString {
        let sourceBytes = sourceCode.syntaxTextBytes
        var output = AttributedString()
        for segment in sourceCode.classifications {
            let sourceByteRange = segment.range.offset ..< segment.range.endOffset
            switch segment.kind {
            case .attribute:
                break
            case .blockComment:
                break
            case .docBlockComment:
                break
            case .docLineComment:
                break
            case .dollarIdentifier:
                break
            case .editorPlaceholder:
                break
            case .floatLiteral:
                break
            case .identifier:
                break
            case .ifConfigDirective:
                break
            case .integerLiteral:
                break
            case .keyword:
                break
            case .lineComment:
                break
            case .none:
                break
            case .operator:
                break
            case .regexLiteral:
                break
            case .stringLiteral:
                break
            case .type:
                break
            case .argumentLabel:
                break
            }
        }
        return output
    }
}
