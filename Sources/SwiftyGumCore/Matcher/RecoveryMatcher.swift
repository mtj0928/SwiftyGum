import Foundation

struct RecoveryMatcher: Matcher {

    public init(configuration: SwiftyGumConfiguration) {
    }

    func match(src: Node, dst: Node, mappingStore: MappingStore) -> MappingStore {
        for srcChild in src.children {
            guard !mappingStore.isMatched(src: srcChild) else {
                continue
            }

            var maxSim = Double.zero
            var maxNode: Node?
            for dstChild in dst.children {
                guard !mappingStore.isMatched(dst: dstChild) else {
                    continue
                }

                if srcChild.label == dstChild.label {
                    let sim: Double
                    if srcChild.isLeaf && dstChild.isLeaf {
                        sim = srcChild.value == dstChild.value ? 1.0 : 0.5
                    } else {
                        sim = similarity(srcChild, dstChild, mappingStore: mappingStore)
                    }

                    if sim > maxSim {
                        maxSim = sim
                        maxNode = dstChild
                    }
                }
            }

            if let node = maxNode {
                mappingStore.link(src: srcChild, dst: node)
                _ = self.match(src: srcChild, dst: node, mappingStore: mappingStore)
            }
        }
        return mappingStore
    }
}
