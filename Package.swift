// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "HPSF",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "HPSF", targets: ["HPSF"]),
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BTree", revision: "407fda73e18cc9df9130453ee36f73408c22408f"),
//        .package(url: "https://github.com/apple/swift-syntax", from: "509.0.0"),
    ],
    targets: [
        .target(name: "HPSF", dependencies: ["BTree", /* "HPSFMacro" */], path: "HPSF"),
//        .macro(
//            name: "HPSFMacro",
//            dependencies: [
//                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
//                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
//            ],
//            path: "HPSFMacro"),
        .testTarget(name: "HPSFTest", dependencies: ["HPSF"], path: "HPSFTest"),
//        .target(name: "HPSFSample", dependencies: ["HPSF"], path: "HPSFSample"),
    ]
)
