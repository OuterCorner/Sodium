// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sodium",
    platforms: [
        .macOS(.v10_10), .iOS(.v9)
        ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Sodium",
            targets: ["Sodium"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "Sodium",
            url: "https://github.com/OuterCorner/Sodium/releases/download/1.0.18+201204.0/Sodium.xcframework.zip",
            checksum: "da4262460cedd7d3e7d89e3d47636811faaa68e10e3e22a6a1917001ccfcf40c"
        )
    ]
)
