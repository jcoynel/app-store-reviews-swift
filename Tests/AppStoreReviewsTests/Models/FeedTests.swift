import XCTest
@testable import AppStoreReviews

final class FeedTests: XCTestCase {
    func testTerritoryIsDerivedFromCurrentPage() throws {
        let url = URL(string: "https://56north.co")!
        let feed = Feed(
            author: Feed.Author(name: "", uri: url),
            entries: [],
            title: "",
            rights: "",
            updated: Date(),
            links: Feed.Links(alternate: url, current: url, first: url, last: url, previous: url, next: url),
            currentPage: try Page(appID: 1, territory: .AE, page: 1),
            firstPage: try Page(appID: 2, territory: .BB, page: 2),
            lastPage: try Page(appID: 3, territory: .CA, page: 3),
            previousPage: try Page(appID: 4, territory: .DE, page: 4),
            nextPage: try Page(appID: 5, territory: .EC, page: 5))

        XCTAssertEqual(feed.territory, .AE)
    }

    func testAppIDIsDerivedFromCurrentPage() throws {
        let url = URL(string: "https://56north.co")!
        let feed = Feed(
            author: Feed.Author(name: "", uri: url),
            entries: [],
            title: "",
            rights: "",
            updated: Date(),
            links: Feed.Links(alternate: url, current: url, first: url, last: url, previous: url, next: url),
            currentPage: try Page(appID: 1, territory: .AE, page: 1),
            firstPage: try Page(appID: 2, territory: .BB, page: 2),
            lastPage: try Page(appID: 3, territory: .CA, page: 3),
            previousPage: try Page(appID: 4, territory: .DE, page: 4),
            nextPage: try Page(appID: 5, territory: .EC, page: 5))

        XCTAssertEqual(feed.appID, 1)
    }

    static var allTests = [
        ("testTerritoryIsDerivedFromCurrentPage", testTerritoryIsDerivedFromCurrentPage),
        ("testAppIDIsDerivedFromCurrentPage", testAppIDIsDerivedFromCurrentPage),
    ]
}
