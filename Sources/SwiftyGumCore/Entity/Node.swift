import SwiftSyntax

class Node {
    let id: SyntaxIdentifier
    let label: String
    let value: String?
    let original: Syntax
    let parent: Node?
    var children: [Node] = []

    init(id: SyntaxIdentifier, original: Syntax, parent: Node?) {
        self.id = id
        self.label = original.label
        self.value = original.token
        self.original = original
        self.parent = parent
    }
}

extension Node: Hashable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        original.hash(into: &hasher)
    }
}

extension Node {

    func same(with node: Node) -> Bool {
        return self.id == node.id
            && self.label == node.label
            && self.value == node.value
    }
}
