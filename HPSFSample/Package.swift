// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "HPSFSample",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "HPSFSample", targets: ["HPSFSample"]),
    ],
    dependencies: [
        .package(path: "../HPSFImpl1"),
    ],
    targets: [
        .target(
            name: "HPSFSample",
            dependencies: [
                .product(name: "HPSFImpl1", package: "HPSFImpl1"/* , moduleAliases: ["HPSFImpl1": "HPSF"] */),
            ]),
    ]
)
