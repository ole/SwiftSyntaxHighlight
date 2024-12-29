// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var package = Package(
    name: "SwiftSyntaxHighlight",
    platforms: [.macOS(.v14), .macCatalyst(.v17), .iOS(.v17), .tvOS(.v17), .watchOS(.v10), .visionOS(.v1)],
    products: [
        .executable(name: "WebAssemblyExecutable", targets: ["WebAssemblyExecutable"]),
        .library(name: "SwiftSyntaxHighlight", targets: ["SwiftSyntaxHighlight"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "600.0.0"),
        .package(url: "https://github.com/swiftwasm/WasmKit.git", from: "0.1.0"),
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
        .executableTarget(
            name: "WebAssemblyExecutable",
            dependencies: [
                "SwiftSyntaxHighlight",
            ]
        ),
        // A CLI app that loads the WebAssembly module and uses it to
        // syntax highlight some Swift code.
        .executableTarget(
            name: "WasmClient",
            dependencies: [
                .product(name: "WasmKit", package: "WasmKit"),
                .product(name: "WasmKitWASI", package: "WasmKit"),
            ]
        ),
        // A SwiftUI app that provides a simple source code editor
        // with Swift syntax highlighting.
        .executableTarget(
            name: "DemoApp",
            dependencies: [
                "SwiftSyntaxHighlight",
            ]
        ),
    ]
)

let swift6Settings: [SwiftSetting] = [
    // SE-0335: Introduce existential any
    // <https://github.com/apple/swift-evolution/blob/main/proposals/0335-existential-any.md>
    .enableUpcomingFeature("ExistentialAny"),
    // SE-0409: Access-level modifiers on import declarations
    // <https://github.com/swiftlang/swift-evolution/blob/main/proposals/0409-access-level-on-imports.md>
    .enableUpcomingFeature("InternalImportsByDefault"),
    // SE-0444: Member import visibility
    // <https://github.com/swiftlang/swift-evolution/blob/main/proposals/0444-member-import-visibility.md>
    .enableUpcomingFeature("MemberImportVisibility"),
]

for idx in package.targets.indices {
    let target = package.targets[idx]
    var newSwiftSettings = target.swiftSettings ?? []
    newSwiftSettings.append(contentsOf: swift6Settings)
    package.targets[idx].swiftSettings = newSwiftSettings
}
