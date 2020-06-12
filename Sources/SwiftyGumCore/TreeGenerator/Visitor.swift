import SwiftSyntax

class Visitor: SyntaxAnyVisitor {

    private(set) var rootNode: Node!
    private(set) var nodes: [SyntaxIdentifier?: Node] = [:]

    override func visitAny(_ syntaxNode: Syntax) -> SyntaxVisitorContinueKind {
        let parent = nodes[syntaxNode.parent?.id]
        let node = Node(id: syntaxNode.id, original: syntaxNode, parent: parent)

        if rootNode == nil {
            rootNode = node
        }
        nodes[syntaxNode.id] = node
        parent?.children = (parent?.children ?? []) + [node]
        return .visitChildren
    }
}
