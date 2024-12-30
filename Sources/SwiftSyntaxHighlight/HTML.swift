import SwiftIDEUtils
public import SwiftSyntax

public struct HTML: OutputFormat {
    public typealias Output = String

    public static func highlight(sourceCode: SourceFileSyntax) -> String {
        let sourceBytes = sourceCode.syntaxTextBytes
        var output: [UInt8] = []
        output.reserveCapacity(sourceBytes.count)
        for segment in sourceCode.classifications {
            let sourceByteRange = segment.range.offset ..< segment.range.endOffset
            let cssClass: String? = switch segment.kind {
            case .attribute: "attribute"
            case .blockComment: "block-comment"
            case .docBlockComment: "doc-block-comment"
            case .docLineComment: "doc-line-comment"
            case .dollarIdentifier: "dollar-identifier"
            case .editorPlaceholder: "editor-placeholder"
            case .floatLiteral: "float-literal"
            case .identifier: "identifier"
            case .ifConfigDirective: "if-config-directive"
            case .integerLiteral: "integer-literal"
            case .keyword: "keyword"
            case .lineComment: "line-comment"
            case .none: nil
            case .operator: "operator"
            case .regexLiteral: "regex-literal"
            case .stringLiteral: "string-literal"
            case .type: "type"
            case .argumentLabel: "argument-label"
            }
            if let cssClass {
                output.append(contentsOf: #"<span class="\#(cssClass)">"#.utf8)
                output.append(contentsOf: sourceBytes[sourceByteRange])
                output.append(contentsOf: #"</span>"#.utf8)
            } else {
                output.append(contentsOf: sourceBytes[sourceByteRange])
            }
        }
        return String(decoding: output, as: UTF8.self)
    }
}
