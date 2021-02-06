import XCTest
import AppStoreReviewsTests

XCTMain([
    testCase(FeedTests.allTests),
    testCase(DecodableFeedTests.allTests),
    testCase(DownloaderTests.allTests),
    testCase(PageExtensionsTests.allTests),
    testCase(TerritoriesTests.allTests),
    testCase(URLExtensionsTests.allTests),
])
