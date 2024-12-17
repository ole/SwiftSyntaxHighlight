// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSyntaxHighlight",
    platforms: [.macOS(.v14), .macCatalyst(.v17), .iOS(.v17), .tvOS(.v17), .watchOS(.v10), .visionOS(.v1)],
    products: [
        .library(
            name: "SwiftSyntaxHighlight",
            targets: ["SwiftSyntaxHighlight"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "600.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftSyntaxHighlight",
            dependencies: [
                .product(name: "SwiftIDEUtils", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "SwiftSyntaxHighlightTests",
            dependencies: ["SwiftSyntaxHighlight"]
        ),
    ]
)
