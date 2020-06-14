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
        hasher.combine(label)
        hasher.combine(value)
        hasher.combine(id.hashValue)
    }
}

extension Node {

    var descents: [Node] {
        var nodes = children.map { $0.descents }
            .flatMap { $0 }
        nodes.insert(self, at: 0)
        return nodes
    }

    func same(with node: Node) -> Bool {
        return self.label == node.label
            && self.value == node.value
    }

    @discardableResult
    func isomorphism(with node: Node) -> [Mapping]? {
        var results = [Mapping]()

        if children.isEmpty {
            guard node.children.isEmpty, same(with: node) else {
                return nil
            }

            results.append(Mapping(src: self, dst: node))
            return results
        }

        if (children.count != node.children.count) {
            return nil
        }

        for index in (0..<children.count) {
            guard let mappings = children[index].isomorphism(with: node.children[index]) else {
                return nil
            }
            results.append(contentsOf: mappings)
        }

        results.append(Mapping(src: self, dst: node))
        return results
    }
}

extension Node {

    func printTree(indent: Int = 0) {
        print("\(String(repeating: " ", count: 2 * indent))\(label): \(value ?? "")")
        children.forEach { $0.printTree(indent: indent + 1) }
    }
}
