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
            switch segment.kind {
            case .attribute:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            case .blockComment:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            case .docBlockComment:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            case .docLineComment:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            case .dollarIdentifier:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            case .editorPlaceholder:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            case .floatLiteral:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            case .identifier:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            case .ifConfigDirective:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            case .integerLiteral:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            case .keyword:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            case .lineComment:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            case .none:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            case .operator:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            case .regexLiteral:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            case .stringLiteral:
                output.append(contentsOf: #"<span class="string-literal">"#.utf8)
                output.append(contentsOf: sourceBytes[sourceByteRange])
                output.append(contentsOf: #"</span>"#.utf8)
            case .type:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            case .argumentLabel:
                output.append(contentsOf: sourceBytes[sourceByteRange])
            }
        }
        return String(decoding: output, as: UTF8.self)
    }
}
