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
            checksum: "fbb97faeaede14ade91c33273cc0d5db791e35950176b089fbef7c81bf62b942"
        )
    ]
)
