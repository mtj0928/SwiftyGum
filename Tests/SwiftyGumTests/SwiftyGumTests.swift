import XCTest
import SwiftyGumCore
import class Foundation.Bundle

final class SwiftyGumTests: XCTestCase {

    func testSample01() throws {
        let projectRoot = productsDirectory.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let sampleDirectory = projectRoot.appendingPathComponent("Resources")
            .appendingPathComponent("sample01")
        let src = sampleDirectory.appendingPathComponent("Src.swift")
        let dst = sampleDirectory.appendingPathComponent("Dst.swift")
        let configuration = SwiftyGumConfiguration(simBorder: 0.1)

        let editScript = try SwiftyGumCore.exec(srcUrl: src, dstUrl: dst, configuration: configuration)
        XCTAssertEqual(editScript.actions.count, 16)
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testSample01", testSample01),
    ]
}
