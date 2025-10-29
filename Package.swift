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
            url: "https://github.com/SnowLukin/XrayKit/releases/download/1.1.1/LibXray.xcframework.zip",
            checksum: "2fa8fe2da0e6575317f3b7f654d23f8e8fe033474bbe3ca3078f6471fac86d04"
        )
    ]
)
