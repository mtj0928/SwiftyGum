import Foundation

struct BottomUpMatcher: Matcher {

    private let minimumSimilarity: Double = 0.3

    func match(src: Node, dst: Node, mappingStore: MappingStore) -> MappingStore {
        let sortedSrcNodes = src.descents.sorted(by: { $0.distanceFromRoot >= $1.distanceFromRoot })
        let labelToDstNode = createLabelToNodes(from: dst)

        for srcNode in sortedSrcNodes {
            guard mappingStore.isMatched(src: srcNode),
                let node = srcNode.parent,
                !mappingStore.isMatched(src: node),
                let candidates = labelToDstNode[node.label] else {
                    continue
            }

            var maxNode: Node?
            var max: Double = 0
            for candidate in candidates {
                if mappingStore.isMatched(dst: candidate) {
                    continue
                }
                let sim = similarity(node, candidate, mappingStore: mappingStore)
                if sim > max && sim >= minimumSimilarity {
                    max = sim
                    maxNode = candidate
                }
            }
            if let maxNode = maxNode {
                mappingStore.link(src: node, dst: maxNode)
                _ = RecoveryMatcher().match(src: node, dst: maxNode, mappingStore: mappingStore)
            }
        }
        return mappingStore
    }
}
