import Foundation
import SwiftSyntax

open class SwifityGumCore {

    public init(srcUrl: URL, dstUrl: URL) throws {
        let srcTree = try TreeGenerator.create(filePath: srcUrl)
        printTree(srcTree)

        let dstTree = try TreeGenerator.create(filePath: dstUrl)
        printTree(dstTree)
    }

    func printTree(_ tree: Node) {
        print(tree.original.description)
        tree.children.forEach { printTree($0) }
    }
}
