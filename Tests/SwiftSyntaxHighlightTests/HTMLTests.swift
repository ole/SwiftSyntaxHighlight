import SwiftSyntaxHighlight
import Testing

@Suite struct HTMLTests {
    @Test func stringLiteral() throws {
        let source = """
            print("Hello world!")
            """
        let expected = """
            <span class="identifier">print</span>(<span class="string-literal">"Hello world!"</span>)
            """
        let actual = highlight(sourceCode: source, as: HTML.self)
        #expect(actual == expected)
    }

    @Test func comments() throws {
        let source = """
            /// This is a doc line comment
            struct S {} // This is a line comment
            """
        let expected = """
            <span class="doc-line-comment">/// This is a doc line comment</span>
            <span class="keyword">struct</span> <span class="identifier">S</span> {} <span class="line-comment">// This is a line comment</span>
            """
        let actual = highlight(sourceCode: source, as: HTML.self)
        #expect(actual == expected)
    }
}
