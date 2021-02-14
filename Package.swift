// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AppStoreReviews",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "AppStoreReviews",
            targets: [
                "AppStoreReviews"
            ]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0"),
    ],
    targets: [
        .target(
            name: "AppStoreReviews",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
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
