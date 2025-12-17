// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "KaseyCodableStore",
    platforms: [
        .iOS(.v17),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "KaseyCodableStore",
            targets: ["KaseyCodableStore"]
        ),
    ],
    targets: [
        .target(
            name: "KaseyCodableStore"
        ),
        .testTarget(
            name: "KaseyCodableStoreTests",
            dependencies: ["KaseyCodableStore"]
        ),
    ]
)
