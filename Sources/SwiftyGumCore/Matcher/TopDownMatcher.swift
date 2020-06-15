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
                    continue
                }
            }
        }
        return mappingStore
    }
}
