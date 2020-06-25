import Foundation
import SwiftSyntax

open class SwifityGumCore {

    public static func exec(srcUrl: URL, dstUrl: URL, configuration: SwiftyGumConfiguration) throws -> EditScript {
        guard srcUrl.pathExtension == "swift" && dstUrl.pathExtension == "swift" else {
            throw SwiftGumError.isNotSwiftFile(src: srcUrl, dst: dstUrl)
        }

        let srcTree = try TreeGenerator.create(filePath: srcUrl)
        let dstTree = try TreeGenerator.create(filePath: dstUrl)

        let matcher = CompositeMatcher(configuration: configuration)
        let mappingStore = matcher.match(src: srcTree, dst: dstTree)

        let generator = ChawatheScriptGenerator()
        return generator.generate(from: mappingStore)
    }
}
