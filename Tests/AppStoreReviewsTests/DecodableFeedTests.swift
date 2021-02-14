import XCTest
@testable import AppStoreReviews

final class DecodableFeedTests: XCTestCase {
    func test_feed_whenOnLastPageGB_isDecodable() throws {
        let json = try TestData.json(fileName: "1510826067_gb_1")
        XCTAssertNoThrow(try JSONDecoder().decode(DecodableFeed.CustomerReviews.self, from: json))
    }

    func test_feed_whenOnLastPageCN_isDecodable() throws {
        let json = try TestData.json(fileName: "497799835_cn_10")
        XCTAssertNoThrow(try JSONDecoder().decode(DecodableFeed.CustomerReviews.self, from: json))
    }

    func test_feed_whenOnFirstPageFR_isDecodable() throws {
        let json = try TestData.json(fileName: "497799835_fr_1")
        XCTAssertNoThrow(try JSONDecoder().decode(DecodableFeed.CustomerReviews.self, from: json))
    }

    func test_feed_whenOnEmptyPage_isDecodable() throws {
        let json = try TestData.json(fileName: "1510826067_gb_2")
        XCTAssertNoThrow(try JSONDecoder().decode(DecodableFeed.CustomerReviews.self, from: json))
    }

    func test_feed_whenOnNonExistingAppPage_isDecodable() throws {
        let json = try TestData.json(fileName: "100000000_gb_1")
        XCTAssertNoThrow(try JSONDecoder().decode(DecodableFeed.CustomerReviews.self, from: json))
    }

    func test_feed_whenExceedingLastPage_isNotDecodable() throws {
        let json = try TestData.json(fileName: "555731861_us_11")
        XCTAssertThrowsError(try JSONDecoder().decode(DecodableFeed.CustomerReviews.self, from: json))
    }
}
