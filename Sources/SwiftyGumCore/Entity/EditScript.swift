public enum EditAction {
    case insert(node: Node, to: Node, pos: Int)
    case delete(node: Node)
    case update(node: Node, newValue: String?)
    case move(node: Node, to: Node, pos: Int)

    public var node: Node {
        switch self {
        case .insert(let node, _, _):
            return node
        case .delete(let node):
            return node
        case .update(let node, _):
            return node
        case .move(let node, _, _):
            return node
        }
    }
}

public struct EditScript {
    public let actions: [EditAction]
    public let mappingStore: MappingStore
    public let srcSourceCode: SourceCode
    public let dstSourceCode: SourceCode
}
