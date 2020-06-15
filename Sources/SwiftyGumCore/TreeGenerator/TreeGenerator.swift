import Foundation
import SwiftSyntax

class TreeGenerator {
    static func create(filePath: URL) throws -> Node {
        let source = try SyntaxParser.parse(filePath)
        let visitor = Visitor()
        visitor.walk(source)
        let root = visitor.rootNode!
        root.updateHeight()
        return root
    }
}
