// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyGum",
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.0.0"),
        .package(name: "SwiftSyntax", url: "https://github.com/apple/swift-syntax.git", .exact("0.50200.0")),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftyGumCLI",
            dependencies: [
                "Commander",
                "SwiftyGumCore",
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
        .target(
            name: "SwiftyGumCore",
            dependencies: [
                "SwiftSyntax",
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
        .testTarget(
            name: "SwiftyGumTests",
            dependencies: ["SwiftyGumCore"]),
    ],
    swiftLanguageVersions: [.v5]
)
