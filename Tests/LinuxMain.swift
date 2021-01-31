import XCTest
import AppStoreReviewsTests

XCTMain([
    testCase(TerritoriesTests.allTests),
    testCase(URLExtensionsTests.allTests),
    testCase(DecodableFeedTests.allTests),
    testCase(DownloaderTests.allTests),
    testCase(PageExtensionsTests.allTests),
    testCase(FeedExtensionsTests.allTests),
])
