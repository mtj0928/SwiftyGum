import Foundation

struct RecoveryMatcher: Matcher {

    func match(src: Node, dst: Node, mappingStore: MappingStore) -> MappingStore {
        for srcChild in src.children {
            guard !mappingStore.isMatched(src: srcChild) else {
                continue
            }

            for dstChild in dst.children {
                guard !mappingStore.isMatched(dst: dstChild) else {
                    continue
                }
                if srcChild.same(with: dstChild) {
                    mappingStore.link(src: srcChild, dst: dstChild)
                    _ = self.match(src: srcChild, dst: dstChild, mappingStore: mappingStore)
                    print("Match in Recovery")
                    print("Src")
                    srcChild.printTree()
                    print("Dst")
                    dstChild.printTree()
                    break
                }
            }
        }
        return mappingStore
    }
}
