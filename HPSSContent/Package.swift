// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HPSSContent",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "HPSSContent", targets: ["HPSSContent"]),
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BTree", revision: "407fda73e18cc9df9130453ee36f73408c22408f"),
//        .package(url: "https://github.com/siteline/swiftui-introspect", revision: "9e1cc02a65b22e09a8251261cccbccce02731fc5"),
    ],
    targets: [
        .target(name: "HPSSContent", dependencies: [
            "BTree",
//            .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
        ]),
    ]
)
