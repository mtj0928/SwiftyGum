import Foundation
import SwiftSyntax

class TreeGenerator {
    static func create(filePath: URL) throws -> Node {
        let source = try SyntaxParser.parse(filePath)
        let visitor = Visitor()
        visitor.walk(source)
        return visitor.rootNode
    }
}
