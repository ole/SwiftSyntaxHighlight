public import SwiftSyntax
import SwiftParser

public protocol OutputFormat {
    associatedtype Output

    static func highlight(sourceCode: SourceFileSyntax) -> Output
}

public func highlight<Format: OutputFormat>(
    sourceCode input: String,
    as format: Format.Type
) -> Format.Output {
    let syntax = Parser.parse(source: input)
    return format.highlight(sourceCode: syntax)
}
