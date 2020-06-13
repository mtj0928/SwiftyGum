import Foundation

class MappingStore {
    private(set) var pairs = [Mapping]()
    private(set) var srcNodeToDstNode = [Node: Node]()
    private(set) var dstNodeToSrctNode = [Node: Node]()

    func mathcedDstNode(with srcNode: Node) -> Node? {
        return srcNodeToDstNode[srcNode]
    }

    func matchedSrcNode(with dstNode: Node) -> Node? {
        return dstNodeToSrctNode[dstNode]
    }
}
