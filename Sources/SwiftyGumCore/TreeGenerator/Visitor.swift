import SwiftSyntax

class Visitor: SyntaxAnyVisitor {

    private(set) var rootNode: Node!
    private(set) var nodes: [SyntaxIdentifier?: Node] = [:]

    private var id = 0

    override func visitAny(_ syntaxNode: Syntax) -> SyntaxVisitorContinueKind {
        let parent = nodes[syntaxNode.parent?.id]

        let node = Node(original: syntaxNode, parent: parent)
        id += 1

        if rootNode == nil {
            rootNode = node
        }
        nodes[syntaxNode.id] = node
        parent?.children = (parent?.children ?? []) + [node]
        return .visitChildren
    }
}
