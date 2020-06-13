import Foundation

protocol Matcher {

    func match(src: Node, dst: Node, mappingStore: MappingStore) -> MappingStore
}

extension Matcher {

    func match(src: Node, dst: Node) -> MappingStore {
        return self.match(src: src, dst: dst, mappingStore: MappingStore())
    }
}
