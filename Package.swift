// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSyntaxHighlight",
    products: [
        .library(
            name: "SwiftSyntaxHighlight",
            targets: ["SwiftSyntaxHighlight"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftSyntaxHighlight"
        ),
        .testTarget(
            name: "SwiftSyntaxHighlightTests",
            dependencies: ["SwiftSyntaxHighlight"]
        ),
    ]
)
