import Foundation
import SwiftSyntax

struct TopDownMathcher: Matcher {

    func match(src srcTree: Node, dst dstTree: Node, mappingStore: MappingStore) -> MappingStore {
        let dstLabelToNodes = createLabelToNodes(from: dstTree)

        for srcNode in srcTree.descents {
            // When the parent node is matched, the node (included in the parent node's childlen) is matched.
            // So, skip the node.
            guard !mappingStore.isMatched(src: srcNode),
                let candidates = dstLabelToNodes[srcNode.label] else {
                continue
            }

            for candidate in candidates {
                if let mappings = srcNode.isomorphism(with: candidate) {
                    mappings.forEach { mappingStore.link($0) }
                    print("----Mathced----")
                    candidate.printTree()
                    continue
                }
            }
        }
        return mappingStore
    }

    private func createLabelToNodes(from node: Node) -> [String: [Node]] {
        return node.descents.reduce([:]) { (dict, node) -> [String: [Node]] in
            var dict = dict
            var nodes = dict[node.label] ?? []
            nodes.append(node)
            dict[node.label] = nodes
            return dict
        }
    }
}
