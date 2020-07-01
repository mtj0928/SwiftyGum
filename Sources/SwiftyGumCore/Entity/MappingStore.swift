import Foundation

public class MappingStore {
    public let srcRootNode: Node
    public let dstRootNode: Node
    public private(set) var pairs = [Mapping]()
    public private(set) var srcNodeToDstNode = [Node: Node]()
    public private(set) var dstNodeToSrctNode = [Node: Node]()

    init(srcNode: Node, dstNode: Node) {
        self.srcRootNode = srcNode
        self.dstRootNode = dstNode
    }

    public func link(src: Node, dst: Node) {
        link(Mapping(src: src, dst: dst))
    }

    public func link(_ mapping: Mapping) {
        pairs.append(mapping)
        assert(srcNodeToDstNode[mapping.srcNode] == nil)
        assert(dstNodeToSrctNode[mapping.dstNode] == nil)
        srcNodeToDstNode[mapping.srcNode] = mapping.dstNode
        dstNodeToSrctNode[mapping.dstNode] = mapping.srcNode
    }

    public func isLinked(src: Node, dst: Node) -> Bool {
        return srcNodeToDstNode[src] == dst
    }

    public func mathcedDstNode(with srcNode: Node) -> Node? {
        return srcNodeToDstNode[srcNode]
    }

    public func matchedSrcNode(with dstNode: Node) -> Node? {
        return dstNodeToSrctNode[dstNode]
    }

    public func isMatched(src node: Node) -> Bool {
        return mathcedDstNode(with: node) != nil
    }

    public func isMatched(dst node: Node) -> Bool {
        return matchedSrcNode(with: node) != nil
    }
}
