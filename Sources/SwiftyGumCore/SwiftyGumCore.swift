import Foundation
import SwiftSyntax

open class SwifityGumCore {

    public init(srcUrl: URL, dstUrl: URL) throws {
        let srcTree = try TreeGenerator.create(filePath: srcUrl)
        let dstTree = try TreeGenerator.create(filePath: dstUrl)

        let matcher = CompositeMatcher()
        matcher.match(src: srcTree, dst: dstTree)
    }
}
