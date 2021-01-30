import XCTest
@testable import AppStoreReviews

final class URLExtensionsTests: XCTestCase {
    func testInitWithInvalidAppIDReturnsNil() {
        XCTAssertNil(URL(appID: 0, territory: .GB, page: 1))
        XCTAssertNil(URL(appID: -1, territory: .GB, page: 1))
    }

    func testInitWithInvalidPageReturnsNil() {
        XCTAssertNil(URL(appID: 1, territory: .GB, page: 0))
        XCTAssertNil(URL(appID: 1, territory: .GB, page: -1))
    }

    func testInitWithValidParametersReturnsURL() {
        XCTAssertEqual(
            URL(appID: 1510826067, territory: .GB, page: 1)?.absoluteString,
            "https://itunes.apple.com/rss/customerreviews/page=1/id=1510826067/sortby=mostrecent/json?l=en&cc=gb"
        )
        XCTAssertEqual(
            URL(appID: 1510826067, territory: .GB, page: 1),
            URL(string: "https://itunes.apple.com/rss/customerreviews/page=1/id=1510826067/sortby=mostrecent/json?l=en&cc=gb")
        )
        XCTAssertEqual(
            URL(appID: 1510826067, territory: .AFG, page: 2),
            URL(string: "https://itunes.apple.com/rss/customerreviews/page=2/id=1510826067/sortby=mostrecent/json?l=en&cc=afg")
        )
        XCTAssertEqual(
            URL(appID: 1510826067, territory: .FR, page: 3),
            URL(string: "https://itunes.apple.com/rss/customerreviews/page=3/id=1510826067/sortby=mostrecent/json?l=en&cc=fr")
        )
        XCTAssertEqual(
            URL(appID: 555731861, territory: .US, page: 4),
            URL(string: "https://itunes.apple.com/rss/customerreviews/page=4/id=555731861/sortby=mostrecent/json?l=en&cc=us")
        )
    }

    static var allTests = [
        ("testInitWithInvalidAppIDReturnsNil", testInitWithInvalidAppIDReturnsNil),
        ("testInitWithInvalidPageReturnsNil", testInitWithInvalidPageReturnsNil),
        ("testInitWithValidParametersReturnsURL", testInitWithValidParametersReturnsURL),
    ]
}
