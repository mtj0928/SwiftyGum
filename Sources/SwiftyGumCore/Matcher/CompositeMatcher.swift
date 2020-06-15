import Foundation

struct CompositeMatcher: Matcher {

    func match(src: Node, dst: Node, mappingStore: MappingStore) -> MappingStore {
        let topDownMatcher = TopDownMathcher()
        let mappingStore = topDownMatcher.match(src: src, dst: dst, mappingStore: mappingStore)
        let bottomUpMatcher = BottomUpMatcher()
        return bottomUpMatcher.match(src: src, dst: dst, mappingStore: mappingStore)
    }
}
