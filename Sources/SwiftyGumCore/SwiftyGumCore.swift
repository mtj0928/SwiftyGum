import Foundation
import AST
import Parser
import Source

open class SwifityGumCore {

    public init(src: String, dst: String) {
        do {
            let sourceFile = try SourceReader.read(at: src)
            let parser = Parser(source: sourceFile)
            let topLevelDecl = try parser.parse()
            let visitor = Visitor()
            _ = try visitor.traverse(topLevelDecl)
        } catch {
            print(error.localizedDescription)
        }
    }
}

class Visitor: ASTVisitor {

    func visit(_ node: FunctionDeclaration) throws -> Bool {
        print("position: \(node.sourceLocation.line) \(node.sourceLocation.column)")
        print(node.textDescription)


        return true
    }
}
