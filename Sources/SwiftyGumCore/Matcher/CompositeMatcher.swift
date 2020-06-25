import Foundation

struct CompositeMatcher: Matcher {

    let configuration: SwiftyGumConfiguration
    let matchers: [Matcher]

    init(configuration: SwiftyGumConfiguration) {
        self.configuration = configuration
        self.matchers = [
            TopDownMathcher(configuration: configuration),
            BottomUpMatcher(configuration: configuration)
        ]
    }

    func match(src: Node, dst: Node, mappingStore: MappingStore) -> MappingStore {
        matchers.reduce(mappingStore) { mappingStore, mathcer in
            mathcer.match(src: src, dst: dst, mappingStore: mappingStore)
        }
    }
}
