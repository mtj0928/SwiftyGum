import Foundation

public class Mapping {
    public let srcNode: Node
    public let dstNode: Node

    init(src: Node, dst: Node) {
        assert(src.label == dst.label)
        self.srcNode = src
        self.dstNode = dst
    }
}
