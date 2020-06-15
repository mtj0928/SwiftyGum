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

    func similarity(_ nodeA: Node, _ nodeB: Node, mappingStore: MappingStore) -> Double {
        var nodeADescents = nodeA.descents
        nodeADescents.removeFirst()

        var nodeBDescents = nodeB.descents
        nodeBDescents.removeFirst()

        let nodeBSet = Set(nodeBDescents)
        var count: Double = 0

        for node in nodeADescents {
            guard let mappedNode = mappingStore.mathcedDstNode(with: node) else {
                continue
            }
            if nodeBSet.contains(mappedNode) {
                count += 1
            }
        }
        return Double(count / (Double(nodeADescents.count + nodeBDescents.count) - count))
    }
}
