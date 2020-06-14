import Foundation

struct CompositeMatcher: Matcher {

    func match(src: Node, dst: Node, mappingStore: MappingStore) -> MappingStore {
        let topDownMatcher = TopDownMathcher()
        var mappingStore = topDownMatcher.match(src: src, dst: dst, mappingStore: mappingStore)
        return mappingStore
    }
}
