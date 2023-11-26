// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "HPSFImpl1",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "HPSFImpl1", targets: ["HPSFImpl1"]),
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BTree", revision: "407fda73e18cc9df9130453ee36f73408c22408f"),
//        .package(url: "https://github.com/apple/swift-syntax", from: "509.0.0"),
    ],
    targets: [
        .target(name: "HPSFImpl1", dependencies: ["BTree", /* "HPSFMacro" */]),
//        .macro(
//            name: "HPSFMacro",
//            dependencies: [
//                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
//                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
//            ],
//            path: "Macros"),
        .testTarget(name: "HPSFTests", dependencies: ["HPSFImpl1"]),
//        .target(name: "HPSFSample", dependencies: ["HPSF"], path: "HPSFSample"),
    ]
)
