// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XrayKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "XrayKit",
            targets: ["XrayKit"]
        ),
    ],
    targets: [
        .target(
            name: "XrayKit",
            dependencies: ["Xray"]
        ),
        .binaryTarget(
            name: "Xray",
            url: "https://github.com/SnowLukin/XrayKit/releases/download/1.0.0/Xray.xcframework.zip",
            checksum: "d5f37c6562e1bc98c5e649e49508d882972bc0724df380569f673d683721e47d"
        )
    ]
)
