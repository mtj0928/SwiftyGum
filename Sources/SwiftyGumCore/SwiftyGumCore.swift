import Foundation
import SwiftSyntax

open class SwifityGumCore {

    public static func exec(srcUrl: URL, dstUrl: URL) throws -> EditScript {
        let srcTree = try TreeGenerator.create(filePath: srcUrl)
        let dstTree = try TreeGenerator.create(filePath: dstUrl)

        let matcher = CompositeMatcher()
        let mappingStore = matcher.match(src: srcTree, dst: dstTree)

        let generator = ChawatheScriptGenerator()
        return generator.generate(from: mappingStore)
    }
}
