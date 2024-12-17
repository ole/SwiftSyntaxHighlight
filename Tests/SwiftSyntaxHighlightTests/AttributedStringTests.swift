import Foundation
import SwiftSyntaxHighlight
import Testing

@Suite struct AttributedStringTests {
    @Test func stringLiteral() throws {
        let source = """
            "Hello world!"
            """
        let expected = AttributedString(source, attributes: AttributeContainer().syntaxClassification(.stringLiteral))
        let actual = highlight(sourceCode: source, as: AttributedString.self)
        #expect(actual == expected)
    }

    @Test func snippet1() throws {
        let source = """
            struct S {
                var x: Int = 0
            }
            
            var s = S()
            s.x += 1
            """
        var expected = AttributedString()
        expected.append(AttributedString("struct", attributes: .init().syntaxClassification(.keyword)))
        expected.append(AttributedString(" ", attributes: .init().syntaxClassification(.none)))
        expected.append(AttributedString("S", attributes: .init().syntaxClassification(.identifier)))
        expected.append(AttributedString(" {\n    ", attributes: .init().syntaxClassification(.none)))
        expected.append(AttributedString("var", attributes: .init().syntaxClassification(.keyword)))
        expected.append(AttributedString(" ", attributes: .init().syntaxClassification(.none)))
        expected.append(AttributedString("x", attributes: .init().syntaxClassification(.identifier)))
        expected.append(AttributedString(": ", attributes: .init().syntaxClassification(.none)))
        expected.append(AttributedString("Int", attributes: .init().syntaxClassification(.type)))
        expected.append(AttributedString(" = ", attributes: .init().syntaxClassification(.none)))
        expected.append(AttributedString("0", attributes: .init().syntaxClassification(.integerLiteral)))
        expected.append(AttributedString("\n}\n\n", attributes: .init().syntaxClassification(.none)))
        expected.append(AttributedString("var", attributes: .init().syntaxClassification(.keyword)))
        expected.append(AttributedString(" ", attributes: .init().syntaxClassification(.none)))
        expected.append(AttributedString("s", attributes: .init().syntaxClassification(.identifier)))
        expected.append(AttributedString(" = ", attributes: .init().syntaxClassification(.none)))
        expected.append(AttributedString("S", attributes: .init().syntaxClassification(.identifier)))
        expected.append(AttributedString("()\n", attributes: .init().syntaxClassification(.none)))
        expected.append(AttributedString("s", attributes: .init().syntaxClassification(.identifier)))
        expected.append(AttributedString(".", attributes: .init().syntaxClassification(.none)))
        expected.append(AttributedString("x", attributes: .init().syntaxClassification(.identifier)))
        expected.append(AttributedString(" ", attributes: .init().syntaxClassification(.none)))
        expected.append(AttributedString("+=", attributes: .init().syntaxClassification(.operator)))
        expected.append(AttributedString(" ", attributes: .init().syntaxClassification(.none)))
        expected.append(AttributedString("1", attributes: .init().syntaxClassification(.integerLiteral)))
        let actual = highlight(sourceCode: source, as: AttributedString.self)
        #expect(actual == expected)
        print(actual)
    }
}
