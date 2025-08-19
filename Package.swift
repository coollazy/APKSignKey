// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APKSignKey",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "APKSignKey",
            targets: [
                "APKSignKey"
            ]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "APKSignKey",
            dependencies: [
            ],
            resources: [
            ]
        ),
    ]
)
