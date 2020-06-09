// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyGum",
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: Version(0, 0, 0)),
    ],
    targets: [
        .target(
            name: "SwiftyGum",
            dependencies: ["Commander", "SwiftyGumCore"]),
        .target(
            name: "SwiftyGumCore",
            dependencies: []),
        .testTarget(
            name: "SwiftyGumTests",
            dependencies: ["SwiftyGum"]),
    ]
)
