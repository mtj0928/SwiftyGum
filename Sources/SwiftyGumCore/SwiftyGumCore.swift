import Foundation
import SwiftSyntax

open class SwifityGumCore {

    public init(srcUrl: URL, dstUrl: URL) throws {
        let srcTree = try TreeGenerator.create(filePath: srcUrl)
        printTree(srcTree)

        let dstTree = try TreeGenerator.create(filePath: dstUrl)
        printTree(dstTree)
    }

    func printTree(_ tree: Node, indent: Int = 0) {
        print("\(String(repeating: " ", count: 2 * indent))\(tree.label): \(tree.value ?? "")")
        tree.children.forEach { printTree($0, indent: indent + 1) }
    }
}
