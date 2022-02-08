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
            url: "https://github.com/OuterCorner/Sodium/releases/download/1.1.0/Sodium.xcframework.zip",
            checksum: "81fbd6489b4bf1a8b1d25e1cd0040858a9433868d17146dfa0cafc2f219a7612"
        )
    ]
)
