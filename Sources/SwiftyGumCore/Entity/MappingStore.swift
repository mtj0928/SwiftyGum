import Foundation

class MappingStore {
    private(set) var pairs = [Mapping]()
    private(set) var srcNodeToDstNode = [Node: Node]()
    private(set) var dstNodeToSrctNode = [Node: Node]()

    func link(src: Node, dst: Node) {
        pairs.append(Mapping(src: src, dst: dst))
        srcNodeToDstNode[src] = dst
        dstNodeToSrctNode[dst] = src
    }

    func link(_ mapping: Mapping) {
        pairs.append(mapping)
        srcNodeToDstNode[mapping.srcNode] = mapping.dstNode
        dstNodeToSrctNode[mapping.dstNode] = mapping.srcNode
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
