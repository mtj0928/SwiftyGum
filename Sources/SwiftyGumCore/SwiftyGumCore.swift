import Foundation
import SwiftSyntax

open class SwifityGumCore {

    public init(srcUrl: URL, dstUrl: URL) throws {
        let srcTree = try TreeGenerator.create(filePath: srcUrl)
        srcTree.printTree()

        print("")
        let dstTree = try TreeGenerator.create(filePath: dstUrl)
        dstTree.printTree()

        let matcher = CompositeMatcher()
        let mappingStore = matcher.match(src: srcTree, dst: dstTree)

        let generator = ChawatheScriptGenerator()
        let editScript = generator.generate(from: mappingStore)

        print(editScript)
    }
}
