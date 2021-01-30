// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AppStoreReviews",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "AppStoreReviews",
            targets: [
                "AppStoreReviews"
            ]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AppStoreReviews",
            dependencies: [
            ]),
        .testTarget(
            name: "AppStoreReviewsTests",
            dependencies: [
                "AppStoreReviews"
            ],
            resources: [
                .copy("Resources")
            ]),
    ]
)
