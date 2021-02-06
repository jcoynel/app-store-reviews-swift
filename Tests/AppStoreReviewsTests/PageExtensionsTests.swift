import XCTest
@testable import AppStoreReviews

final class PageExtensionsTests: XCTestCase {
    // MARK: - Failure

    func testInvalidMiscUrlsReturnNil() {
        XCTAssertNil(Page(URL(string: "https://56north.co")!))
        XCTAssertNil(Page(URL(string: "https://world-heritage.app")!))
        XCTAssertNil(Page(URL(string: "https://github.com/jcoynel/app-store-reviews-swift")!))
        XCTAssertNil(Page(URL(string: "ftp://test@example.com")!))
        XCTAssertNil(Page(URL(string: "file://some/path/example.json")!))
        XCTAssertNil(Page(URL(string: "//some/path/example.json")!))
    }

    func testInvalidFeedUrlsReturnNil() {
        XCTAssertNil(Page(URL(string: "https://itunes.apple.com/rss/customerreviews/page=0/id=497799835/sortby=mostrecent/json?l=en&cc=cn")!))
        XCTAssertNil(Page(URL(string: "https://itunes.apple.com/rss/customerreviews/page=1/id=-1/sortby=mostrecent/json?l=en&cc=cn")!))
        XCTAssertNil(Page(URL(string: "https://itunes.apple.com/fr/rss/customerreviews/page=abc/id=1/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=1/id=1/sortby=mostrecent/json")!))
        XCTAssertNil(Page(URL(string: "https://itunes.apple.com/fr/rss/customerreviews/page=2/id=abc/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=1/id=1/sortby=mostrecent/json")!))
        XCTAssertNil(Page(URL(string: "https://itunes.apple.com/rss/customerreviews/page=1/id=abc/sortby=mostrecent/json?l=en&cc=cn")!))
        XCTAssertNil(Page(URL(string: "https://itunes.apple.com/rss/customerreviews/page=abc/id=1/sortby=mostrecent/json?l=en&cc=cn")!))
        XCTAssertNil(Page(URL(string: "https://itunes.apple.com/rss/customerreviews/page=1/id=1/sortby=mostrecent/json?l=en&cc=abc")!))
    }

    func testInvalidLinkUrlsReturnNil() {
        XCTAssertNil(Page(URL(string: "https://itunes.apple.com/rss/customerreviews/page=2/id=1/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=2/id=1/sortby=mostrecent/json")!))
        XCTAssertNil(Page(URL(string: "https://itunes.apple.com/abc/rss/customerreviews/page=2/id=1/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=2/id=1/sortby=mostrecent/json")!))
        XCTAssertNil(Page(URL(string: "https://itunes.apple.com/fr/rss/customerreviews/page=2/id=abc/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=1/id=1/sortby=mostrecent/json")!))
        XCTAssertNil(Page(URL(string: "https://itunes.apple.com/fr/rss/customerreviews/page=2/id=0/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=1/id=0/sortby=mostrecent/json")!))
    }

    // MARK: - Success

    func testUrlsCreatedFromPageReturnEqualPage() {
        guard let page1 = try? Page(appID: 1510826067, territory: .GB, page: 2),
              let page2 = try? Page(appID: 1, territory: .GB, page: 100),
              let page1URL = URL(page1), let page2URL = URL(page2) else {
            return XCTFail("Failed to generate test urls")
        }
        XCTAssertEqual(Page(page1URL), page1)
        XCTAssertEqual(Page(page2URL), page2)
    }

    func testValidLinkUrlReturnsPage() {
        let url1 = URL(string: "https://itunes.apple.com/rss/customerreviews/page=10/id=497799835/sortby=mostrecent/json?l=en&cc=cn")!
        let url2 = URL(string: "https://itunes.apple.com/fr/rss/customerreviews/page=2/id=1/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=3/id=1/sortby=mostrecent/json")!
        let url3 = URL(string: "https://itunes.apple.com/cn/rss/customerreviews/page=10/id=497799835/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=9/id=497799835/sortby=mostrecent/json")!
        let url4 = URL(string: "https://itunes.apple.com/cn/rss/customerreviews/page=9/id=497799835/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=10/id=497799835/sortby=mostrecent/json")!
        let url5 = URL(string: "https://itunes.apple.com/cn/rss/customerreviews/page=1/id=497799835/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=7/id=497799835/sortby=mostrecent/json")!

        XCTAssertEqual(Page(url1), try Page(appID: 497799835, territory: .CN, page: 10))
        XCTAssertEqual(Page(url2), try Page(appID: 1, territory: .FR, page: 2))
        XCTAssertEqual(Page(url3), try Page(appID: 497799835, territory: .CN, page: 10))
        XCTAssertEqual(Page(url4), try Page(appID: 497799835, territory: .CN, page: 9))
        XCTAssertEqual(Page(url5), try Page(appID: 497799835, territory: .CN, page: 1))
    }

    static var allTests = [
        ("testInvalidMiscUrlsReturnNil", testInvalidMiscUrlsReturnNil),
        ("testInvalidFeedUrlsReturnNil", testInvalidFeedUrlsReturnNil),
        ("testInvalidLinkUrlsReturnNil", testInvalidLinkUrlsReturnNil),
        ("testUrlsCreatedFromPageReturnEqualPage", testUrlsCreatedFromPageReturnEqualPage),
        ("testValidLinkUrlReturnsPage", testValidLinkUrlReturnsPage),
    ]
}
