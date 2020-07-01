import Foundation
import SwiftSyntax

class TreeGenerator {

    static func create(sourceCode: SourceCode) throws -> Node {
        let source = try SyntaxParser.parse(source: sourceCode.text)
        let visitor = Visitor()
        visitor.walk(source)
        let root = visitor.rootNode!
        root.updateHeight()
        return root
    }
}
