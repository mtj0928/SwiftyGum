enum EditAction {
    case insert(node: Node, to: Node, pos: Int)
    case delete(node: Node)
    case update(node: Node, newValue: String)
    case move(node: Node, to: Node, pos: Int)
}

struct EditScript {
    let action: [EditAction]
}
