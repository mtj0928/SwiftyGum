import SwiftSyntax

open class Node {
    public let id: Int
    public let label: String
    public var value: String?
    public let original: Syntax?
    public weak var parent: Node?
    public var children: [Node] = []
    public private(set) var height = 0
    public private(set) var distanceFromRoot = 0
    public private(set) lazy var rootNode: Node = { () -> Node in
        let node = parent?.rootNode
        return node ?? self
    }()
    private var idCounter = 0

    init(original: Syntax?, parent: Node?) {
        self.label = original?.label ?? "Unknown"
        self.value = original?.token
        self.original = original
        self.parent = parent
        self.id = parent?.newId() ?? 0
    }

    init(label: String, value: String?, parent: Node?) {
        self.label = label
        self.value = value
        self.original = nil
        self.parent = parent
        self.id = parent?.newId() ?? 0
    }
}

// MARK: - Hashable

extension Node: Hashable {
    public static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        original.hash(into: &hasher)
    }
}

// MARK: - Logic

extension Node {

    var posionInParent: Int? {
        return parent?.children.firstIndex(of: self)
    }

    public var descents: [Node] {
        var nodes = children.map { $0.descents }
            .flatMap { $0 }
        nodes.insert(self, at: 0)
        return nodes
    }

    public var isRoot: Bool {
        parent == nil
    }

    public var isLeaf: Bool {
        return children.isEmpty
    }

    public func same(with node: Node) -> Bool {
        return self.label == node.label
            && self.value == node.value
    }

    @discardableResult
    public func isomorphism(with node: Node) -> [Mapping]? {
        guard height == node.height else {
            return nil
        }

        var results = [Mapping]()

        if children.count != node.children.count {
            return nil
        }

        if isLeaf {
            guard same(with: node) else {
                return nil
            }

            results.append(Mapping(src: self, dst: node))
            return results
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

    @discardableResult
    public func updateHeight(distanceFromRoot: Int = 0) -> Int {
        self.distanceFromRoot = distanceFromRoot
        guard let height = children.map({ $0.updateHeight(distanceFromRoot: distanceFromRoot + 1) }).max() else {
            // A case when children are empty
            self.height = 0
            return 0
        }
        self.height = height + 1
        return self.height
    }

    public func deepCopy() -> Node {
        return deepCopy(parent: nil)
    }

    private func deepCopy(parent: Node?) -> Node {
        let node = Node(original: original, parent: parent)
        node.height = height
        node.distanceFromRoot = distanceFromRoot
        self.children.forEach { child in
            let child = child.deepCopy(parent: node)
            node.children.append(child)
        }
        return node
    }

    func newId() -> Int {
        if parent == nil {
            idCounter += 1
            return idCounter
        }
        return rootNode.newId()
    }
}

// MARK: - Debug

extension Node {

    public func printTree(indent: Int = 0) {
        print("\(String(repeating: " ", count: 2 * indent))\(id). \(label): \(value ?? "")")
        children.forEach { $0.printTree(indent: indent + 1) }
    }
}
