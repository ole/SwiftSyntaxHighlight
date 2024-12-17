import SwiftSyntaxHighlight
import Testing

@Test func stringLiteral() throws {
    let source = """
        print("Hello world!")
        """
    let expected = """
        print(<span class="string-literal">"Hello world!"</span>)
        """
    let actual = highlight(sourceCode: source, as: HTML.self)
    #expect(actual == expected)
}
