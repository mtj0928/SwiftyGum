// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyGum",
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.0.0"),
        .package(url: "https://github.com/yanagiba/swift-ast.git", from: "0.19.9"),
    ],
    targets: [
        .target(
            name: "SwiftyGumCore",
            dependencies: [
                .product(name: "SwiftAST+Tooling", package: "swift-ast")
            ]
        ),
        .target(
            name: "SwiftyGumCLI",
            dependencies: [
                "Commander",
                "SwiftyGumCore",
            ]
        ),
        .testTarget(
            name: "SwiftyGumTests",
            dependencies: ["SwiftyGumCore"]),
    ],
    swiftLanguageVersions: [.v5]
)
