import Foundation

protocol Matcher {

    func match(src: Node, dst: Node, mappingStore: MappingStore) -> MappingStore
}

extension Matcher {

    func match(src: Node, dst: Node) -> MappingStore {
        return self.match(src: src, dst: dst, mappingStore: MappingStore())
    }

    func createLabelToNodes(from node: Node) -> [String: [Node]] {
        createLabelToNodes(from: node.descents)
    }

    func createLabelToNodes(from nodes: [Node]) -> [String: [Node]] {
        return nodes.reduce([:]) { (dict, node) -> [String: [Node]] in
            var dict = dict
            var nodes = dict[node.label] ?? []
            nodes.append(node)
            dict[node.label] = nodes
            return dict
        }
    }
}
