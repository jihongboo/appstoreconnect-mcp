// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "appstoreconnect-mcp",
    platforms: [
        .macOS(.v15)
    ],
    dependencies: [
        .package(
            url: "https://github.com/AvdLee/appstoreconnect-swift-sdk.git",
            .upToNextMajor(from: "4.0.0")
        ),
        .package(
            url: "https://github.com/modelcontextprotocol/swift-sdk.git",
            from: "0.11.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "appstoreconnect-mcp",
            dependencies: [
                .product(name: "AppStoreConnect-Swift-SDK", package: "appstoreconnect-swift-sdk"),
                .product(name: "MCP", package: "swift-sdk"),
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6),
                .enableUpcomingFeature("MemberImportVisibility"),
            ]
        ),
    ]
)
