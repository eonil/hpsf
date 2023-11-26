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
        .package(path: "HPSFImpl1"),
    ],
    targets: [
        .target(name: "HPSF", dependencies: ["HPSFImpl1"], path: "HPSF"),
    ]
)
