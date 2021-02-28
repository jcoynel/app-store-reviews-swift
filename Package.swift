// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "app-store-reviews",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "AppStoreReviews",
            targets: [
                "AppStoreReviews",
            ]),
        .executable(
            name: "app-store-reviews",
            targets: [
                "app-store-reviews",
            ])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.0"),
    ],
    targets: [
        .target(
            name: "AppStoreReviews",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ]),
        .target(
            name: "app-store-reviews",
            dependencies: [
                "AppStoreReviews",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "AppStoreReviewsTests",
            dependencies: [
                "AppStoreReviews"
            ],
            resources: [
                .copy("TestData")
            ]),
    ]
)
