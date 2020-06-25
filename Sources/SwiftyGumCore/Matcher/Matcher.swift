import Foundation

protocol Matcher {

    init(configuration: SwiftyGumConfiguration)

    func match(src: Node, dst: Node, mappingStore: MappingStore) -> MappingStore
}

extension Matcher {

    func match(src: Node, dst: Node) -> MappingStore {
        return self.match(src: src, dst: dst, mappingStore: MappingStore(srcNode: src, dstNode: dst))
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

    func similarity(_ nodeA: Node, _ nodeB: Node, mappingStore: MappingStore) -> Double {
        let nodeADescents = nodeA.descents
        let nodeBSet = Set(nodeB.descents)

        let count = Double(nodeADescents.compactMap { mappingStore.mathcedDstNode(with: $0) }
            .filter { nodeBSet.contains($0) }
            .count
        )
        let sim = Double(count / (Double(nodeADescents.count + nodeBSet.count) - count))
        return sim
    }
}
