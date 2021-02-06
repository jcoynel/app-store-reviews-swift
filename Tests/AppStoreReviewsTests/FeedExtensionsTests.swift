import XCTest
@testable import AppStoreReviews

final class FeedExtensionsTests: XCTestCase {
    func testCurrentPageIsEqualToLinksCurrentPage() {
        let feed = testFeed(
            links: Feed.Links(
                alternate: fakeLink,
                current: exampleLink(123),
                first: exampleLink(1),
                last: exampleLink(200),
                previous: exampleLink(122),
                next: exampleLink(124)))

        XCTAssertEqual(feed.currentPage, expectedPage(123))
    }

    func testFirstPageIsEqualToLinksFirstPage() {
        let feed = testFeed(
            links: Feed.Links(
                alternate: fakeLink,
                current: exampleLink(123),
                first: exampleLink(1),
                last: exampleLink(200),
                previous: exampleLink(122),
                next: exampleLink(124)))

        XCTAssertEqual(feed.firstPage, expectedPage(1))
    }

    func testLastPageIsEqualToLinksLastPage() {
        let feed = testFeed(
            links: Feed.Links(
                alternate: fakeLink,
                current: exampleLink(123),
                first: exampleLink(1),
                last: exampleLink(200),
                previous: exampleLink(122),
                next: exampleLink(124)))

        XCTAssertEqual(feed.lastPage, expectedPage(200))
    }

    func testPreviousPageIsEqualToLinksCurrentPageMinusOne() {
        let feed = testFeed(
            links: Feed.Links(
                alternate: fakeLink,
                current: exampleLink(123),
                first: exampleLink(1),
                last: exampleLink(200),
                previous: exampleLink(122),
                next: exampleLink(124)))

        XCTAssertEqual(feed.previousPage, expectedPage(122))
    }

    func testPreviousPageIsNilWhenCurrentPageIsTheFirst() {
        let feed = testFeed(
            links: Feed.Links(
                alternate: fakeLink,
                current: exampleLink(1),
                first: exampleLink(1),
                last: exampleLink(200),
                previous: exampleLink(122),
                next: exampleLink(124)))

        XCTAssertNil(feed.previousPage)
    }

    func testNextPageIsEqualToLinksNextPagePlusOne() {
        let feed = testFeed(
            links: Feed.Links(
                alternate: fakeLink,
                current: exampleLink(123),
                first: exampleLink(1),
                last: exampleLink(200),
                previous: exampleLink(122),
                next: exampleLink(124)))

        XCTAssertEqual(feed.nextPage, expectedPage(124))
    }

    func testNextPageIsNilWhenCurrentPageIsTheLast() {
        let feed = testFeed(
            links: Feed.Links(
                alternate: fakeLink,
                current: exampleLink(200),
                first: exampleLink(1),
                last: exampleLink(200),
                previous: exampleLink(122),
                next: exampleLink(124)))

        XCTAssertNil(feed.nextPage)
    }

    static var allTests = [
        ("testCurrentPageIsEqualToLinksCurrentPage", testCurrentPageIsEqualToLinksCurrentPage),
        ("testFirstPageIsEqualToLinksFirstPage", testFirstPageIsEqualToLinksFirstPage),
        ("testLastPageIsEqualToLinksLastPage", testLastPageIsEqualToLinksLastPage),
        ("testPreviousPageIsEqualToLinksCurrentPageMinusOne", testPreviousPageIsEqualToLinksCurrentPageMinusOne),
        ("testPreviousPageIsNilWhenCurrentPageIsTheFirst", testPreviousPageIsNilWhenCurrentPageIsTheFirst),
        ("testNextPageIsEqualToLinksNextPagePlusOne", testNextPageIsEqualToLinksNextPagePlusOne),
        ("testNextPageIsNilWhenCurrentPageIsTheLast", testNextPageIsNilWhenCurrentPageIsTheLast),
    ]
}

// MARK: - Helpers

private extension FeedExtensionsTests {
    func testFeed(links: Feed.Links) -> Feed {
        Feed(
            author: Feed.Author(name: "", uri: fakeLink),
            entries: [],
            title: "",
            rights: "",
            updated: Date(),
            links: links)
    }

    var fakeLink: URL {
        URL(string: "https://56north.co")!
    }

    func exampleLink(_ pageNumber: Int) -> URL {
        URL(string: "https://itunes.apple.com/gb/rss/customerreviews/page=\(pageNumber)/id=1510826067/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=\(pageNumber)/id=1510826067/sortby=mostrecent/json")!
    }

    func expectedPage(_ pageNumber: Int) -> Page {
        try! Page(appID: 1510826067, territory: .GB, page: pageNumber)
    }
}
