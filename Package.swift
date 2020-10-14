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
            url: "https://github.com/OuterCorner/Sodium/releases/download/1.0.18+201014.0/Sodium.xcframework.zip",
            checksum: "ee4dadc153329ab5b3f11aa73a64ed677be1026017819f7b3b198fc4d5c35986"
        )
    ]
)
