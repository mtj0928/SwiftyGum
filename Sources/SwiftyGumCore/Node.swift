import SwiftSyntax

class Node {
    let id: SyntaxIdentifier
    let original: Syntax
    let parent: Node?
    var children: [Node] = []

    init(id: SyntaxIdentifier, original: Syntax, parent: Node?) {
        self.id = id
        self.original = original
        self.parent = parent
    }
}
