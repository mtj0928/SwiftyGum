import Foundation

class MappingStore {
    let srcRootNode: Node
    let dstRootNode: Node
    private(set) var pairs = [Mapping]()
    private(set) var srcNodeToDstNode = [Node: Node]()
    private(set) var dstNodeToSrctNode = [Node: Node]()

    init(srcNode: Node, dstNode: Node) {
        self.srcRootNode = srcNode
        self.dstRootNode = dstNode
    }

    func link(src: Node, dst: Node) {
        link(Mapping(src: src, dst: dst))
    }

    func link(_ mapping: Mapping) {
        pairs.append(mapping)
        assert(srcNodeToDstNode[mapping.srcNode] == nil)
        assert(dstNodeToSrctNode[mapping.dstNode] == nil)
        srcNodeToDstNode[mapping.srcNode] = mapping.dstNode
        dstNodeToSrctNode[mapping.dstNode] = mapping.srcNode
    }

    func isLinked(src: Node, dst: Node) -> Bool {
        return srcNodeToDstNode[src] == dst
    }

    func mathcedDstNode(with srcNode: Node) -> Node? {
        return srcNodeToDstNode[srcNode]
    }

    func matchedSrcNode(with dstNode: Node) -> Node? {
        return dstNodeToSrctNode[dstNode]
    }

    func isMatched(src node: Node) -> Bool {
        return mathcedDstNode(with: node) != nil
    }

    func isMatched(dst node: Node) -> Bool {
        return matchedSrcNode(with: node) != nil
    }
}
