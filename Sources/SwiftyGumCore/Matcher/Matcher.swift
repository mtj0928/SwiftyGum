import Foundation

protocol Matcher {

    func match(src: Node, dst: Node) -> MatchingResult 
}

class MatchingResult {
    private(set) var pairs = [MatchingPair]()
    private(set) var srcNodeToDstNode = [Node: Node]()
    private(set) var dstNodeToSrctNode = [Node: Node]()

    func mathcedDstNode(with srcNode: Node) -> Node? {
        return srcNodeToDstNode[srcNode]
    }

    func matchedSrcNode(with dstNode: Node) -> Node? {
        return dstNodeToSrctNode[dstNode]
    }
}

class MatchingPair {
    let srcNode: Node
    let dstNode: Node

    init(src: Node, dst: Node) {
        self.srcNode = src
        self.dstNode = dst
    }
}
