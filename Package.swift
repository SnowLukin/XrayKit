// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XrayKit",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "XrayKit",
            targets: ["XrayKit"]
        ),
    ],
    targets: [
        .target(
            name: "XrayKit",
            dependencies: ["LibXray"]
        ),
        .binaryTarget(
            name: "LibXray",
            url: "https://github.com/SnowLukin/XrayKit/releases/download/1.1.0/LibXray.xcframework.zip",
            checksum: "d955ebd94570e5ac8e7e7bd0cde3440435c6557d18112b9d328366ccb0562d08"
        )
    ]
)
