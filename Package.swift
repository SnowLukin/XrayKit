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
            url: "https://github.com/SnowLukin/XrayKit/releases/download/1.0.4/Xray.xcframework.zip",
            checksum: "0527a41aa5975a620045bc36f6a516f2516b194fbf8d25eab4c701af076c9aea"
        )
    ]
)
