import Foundation
import SwiftSyntax

struct TopDownMathcher: Matcher {

    // 0 means that the node is a leaf.
    private let configuration: SwiftyGumConfiguration

    public init(configuration: SwiftyGumConfiguration) {
        self.configuration = configuration
    }

    func match(src srcTree: Node, dst dstTree: Node, mappingStore: MappingStore) -> MappingStore {
        let dstLabelToNodes = createLabelToNodes(from: dstTree)

        for srcNode in srcTree.descents.sorted(by: { $0.height >= $1.height }) {
            // When the parent node is matched, the node (included in the parent node's childlen) is matched.
            // So, skip the node.
            guard srcNode.height >= configuration.minHeight,
                !mappingStore.isMatched(src: srcNode),
                let candidates = dstLabelToNodes[srcNode.label] else {
                    continue
            }

            for candidate in candidates {
                guard !mappingStore.isMatched(dst: candidate) else {
                    continue
                }

                if let mappings = srcNode.isomorphism(with: candidate) {
                    mappings.forEach { mappingStore.link($0) }
                    break
                }
            }
        }
        return mappingStore
    }
}
