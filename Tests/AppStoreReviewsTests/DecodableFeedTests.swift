import XCTest
@testable import AppStoreReviews

final class DecodableFeedTests: XCTestCase {
    func testDecodableFeedJsonIsDecodableWhenOnLastPageGB() throws {
        let json = try TestData.json(fileName: "1510826067_gb_1")
        XCTAssertNoThrow(try JSONDecoder().decode(DecodableFeed.CustomerReviews.self, from: json))
    }

    func testDecodableFeedJsonIsDecodableWhenOnLastPageCN() throws {
        let json = try TestData.json(fileName: "497799835_cn_10")
        XCTAssertNoThrow(try JSONDecoder().decode(DecodableFeed.CustomerReviews.self, from: json))
    }

    func testDecodableFeedJsonIsDecodableWhenOnFirstPageFR() throws {
        let json = try TestData.json(fileName: "497799835_fr_1")
        XCTAssertNoThrow(try JSONDecoder().decode(DecodableFeed.CustomerReviews.self, from: json))
    }

    func testDecodableFeedJsonIsDecodableWhenOnEmptyPage() throws {
        let json = try TestData.json(fileName: "1510826067_gb_2")
        XCTAssertNoThrow(try JSONDecoder().decode(DecodableFeed.CustomerReviews.self, from: json))
    }

    func testDecodableFeedJsonIsDecodableForNonExistingApp() throws {
        let json = try TestData.json(fileName: "100000000_gb_1")
        XCTAssertNoThrow(try JSONDecoder().decode(DecodableFeed.CustomerReviews.self, from: json))
    }

    func testDecodableFeedJsonIsNotDecodableWhenExceedingLastPage() throws {
        let json = try TestData.json(fileName: "555731861_us_11")
        XCTAssertThrowsError(try JSONDecoder().decode(DecodableFeed.CustomerReviews.self, from: json))
    }

    static var allTests = [
        ("testDecodableFeedJsonIsDecodableWhenOnLastPageGB", testDecodableFeedJsonIsDecodableWhenOnLastPageGB),
        ("testDecodableFeedJsonIsDecodableWhenOnLastPageCN", testDecodableFeedJsonIsDecodableWhenOnLastPageCN),
        ("testDecodableFeedJsonIsDecodableWhenOnFirstPageFR", testDecodableFeedJsonIsDecodableWhenOnFirstPageFR),
        ("testDecodableFeedJsonIsDecodableWhenOnEmptyPage", testDecodableFeedJsonIsDecodableWhenOnEmptyPage),
        ("testDecodableFeedJsonIsDecodableForNonExistingApp", testDecodableFeedJsonIsDecodableForNonExistingApp),
        ("testDecodableFeedJsonIsNotDecodableWhenExceedingLastPage", testDecodableFeedJsonIsNotDecodableWhenExceedingLastPage),
    ]
}
