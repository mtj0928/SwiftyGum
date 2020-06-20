import Foundation

class Mapping {
    let srcNode: Node
    let dstNode: Node

    init(src: Node, dst: Node) {
        assert(src.label == dst.label)
        self.srcNode = src
        self.dstNode = dst
    }
}
