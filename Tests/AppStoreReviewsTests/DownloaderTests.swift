import XCTest
@testable import AppStoreReviews

final class DownloaderTests: XCTestCase {
    var sut: Downloader!
    var urlSession: URLSession!

    override func setUpWithError() throws {
        MockURLProtocol.mockResponse = .none

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)

        sut = Downloader(urlSession: urlSession)
    }

    override func tearDownWithError() throws {
        urlSession.invalidateAndCancel()
        MockURLProtocol.mockResponse = .none
    }

    // MARK: - Fetch with Publisher (Combine)
    // MARK: Errors

    #if canImport(Combine)

    func test_fetchPublisher_withInvalidHTTPCode_returnsInvalidHTTPResponseStatusError() throws {
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(statusCode: 500, data: Data()))

        let exp = expectation(description: "Response error")
        let sub = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1))
            .sink { completion in
                if case .failure(let error) = completion,
                   case .invalidHTTPResponseStatus(code: let code) = error,
                   code == 500 {
                    exp.fulfill()
                }
            } receiveValue: { feed in
                XCTFail("Unexpected value received: \(feed)")
            }

        waitForExpectations(timeout: 1)
        sub.cancel()
    }

    func test_fetchPublisher_withNonHTTPResponse_returnsInvalidResponseError() throws {
        MockURLProtocol.mockResponse = .nonHTTPURLResponse

        let exp = expectation(description: "Response error")
        let sub = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1))
            .sink { completion in
                if case .failure(let error) = completion,
                   case .invalidResponse = error {
                    exp.fulfill()
                }
            } receiveValue: { feed in
                XCTFail("Unexpected value received: \(feed)")
            }

        waitForExpectations(timeout: 1)
        sub.cancel()
    }

    func test_fetchPublisher_withInvalidJSON_returnsJsonDecoderError() throws {
        let mockData = try TestData.json(fileName: "555731861_us_11")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        let exp = expectation(description: "Response error")
        let sub = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1))
            .sink { completion in
                if case .failure(let error) = completion,
                   case .jsonDecoder = error {
                    exp.fulfill()
                }
            } receiveValue: { feed in
                XCTFail("Unexpected value received: \(feed)")
            }

        waitForExpectations(timeout: 1)
        sub.cancel()
    }

    func test_fetchPublisher_withNoResponse_returnsNetworkError() throws {
        MockURLProtocol.mockResponse = .none

        let exp = expectation(description: "Response error")
        let sub = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1))
            .sink { completion in
                if case .failure(let error) = completion,
                   case .networkError = error {
                    exp.fulfill()
                }
            } receiveValue: { feed in
                XCTFail("Unexpected value received: \(feed)")
            }

        waitForExpectations(timeout: 1)
        sub.cancel()
    }

    func test_fetchPublisher_withError_returnsNetworkError() throws {
        MockURLProtocol.mockResponse = .error(URLError(.networkConnectionLost))

        var receivedUnderlyingError: Error?
        let exp = expectation(description: "Response error")
        let sub = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1))
            .sink { completion in
                if case .failure(let error) = completion,
                   case .networkError(let returnedError) = error {
                    receivedUnderlyingError = returnedError
                    exp.fulfill()
                }
            } receiveValue: { feed in
                XCTFail("Unexpected value received: \(feed)")
            }
        waitForExpectations(timeout: 1)
        XCTAssertEqual((receivedUnderlyingError as? URLError)?.code, URLError.Code.networkConnectionLost)
        sub.cancel()
    }

    func test_fetchPublisher_withInvalidFeedAuthorUri_returnsInvalidDataError() throws {
        let mockData = try TestData.json(fileName: "invalid_feed_author_uri")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        let exp = expectation(description: "Response error")
        let sub = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1))
            .sink { completion in
                if case .failure(let error) = completion,
                   case .invalidData = error {
                    exp.fulfill()
                }
            } receiveValue: { feed in
                XCTFail("Unexpected value received: \(feed)")
            }

        waitForExpectations(timeout: 1)
        sub.cancel()
    }

    func test_fetchPublisher_withInvalidLinks_returnsInvalidDataError() throws {
        let mockData = try TestData.json(fileName: "invalid_links")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        let exp = expectation(description: "Response error")
        let sub = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1))
            .sink { completion in
                if case .failure(let error) = completion,
                   case .invalidData = error {
                    exp.fulfill()
                }
            } receiveValue: { feed in
                XCTFail("Unexpected value received: \(feed)")
            }

        waitForExpectations(timeout: 1)
        sub.cancel()
    }

    // MARK: Success

    func test_fetchPublisher_withValidContent_returnsValidData() throws {
        let mockData = try TestData.json(fileName: "497799835_cn_10")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        var receivedValue: Feed?
        let exp = expectation(description: "Response success")
        let sub = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1))
            .sink { completion in
                if case .finished = completion {
                    exp.fulfill()
                }
            } receiveValue: { feed in
                receivedValue = feed
            }

        waitForExpectations(timeout: 1)
        sub.cancel()
        let value = try XCTUnwrap(receivedValue)
        XCTAssertEqual(value.entries.count, 50)
        XCTAssertEqual(value.author, Feed.Author(
                        name: "iTunes Store",
                        uri: URL(string: "http://www.apple.com/uk/itunes/")!)
        )
        XCTAssertEqual(value.entries.first, Feed.Entry(
                        author: Feed.Author(name: "lxzyzwoout", uri: URL(string: "https://itunes.apple.com/cn/reviews/id552914365?l=en")!),
                        appVersion: "12.0",
                        rating: 1,
                        id: "6455612413",
                        title: "越来越烂",
                        description: "其他的工具都是越开发越好用，就Xcode例外，越开发越难用",
                        voteCount: 2,
                        voteSum: 1,
                        territory: .CN,
                        appID: 497799835))
        XCTAssertEqual(value.title, "iTunes Store: Customer Reviews")
        XCTAssertEqual(value.rights, "Copyright 2008 Apple Inc.")
        // 2021-01-30T12:52:46-07:00
        let expectedDate = DateComponents(calendar: .current, timeZone: TimeZone(secondsFromGMT: -7 * 60 * 60), year: 2021, month: 1, day: 30, hour: 12, minute: 52, second: 46).date
        XCTAssertEqual(value.updated, expectedDate)
        let expectedLinks = Feed.Links(
            alternate: URL(string: "https://apps.apple.com/WebObjects/MZStore.woa/wa/viewGrouping?cc=cn&id=29099&l=en")!,
            current: URL(string: "https://itunes.apple.com/rss/customerreviews/page=10/id=497799835/sortby=mostrecent/json?l=en&cc=cn")!,
            first: URL(string: "https://itunes.apple.com/cn/rss/customerreviews/page=1/id=497799835/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=10/id=497799835/sortby=mostrecent/json")!,
            last: URL(string: "https://itunes.apple.com/cn/rss/customerreviews/page=10/id=497799835/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=10/id=497799835/sortby=mostrecent/json")!,
            previous: URL(string: "https://itunes.apple.com/cn/rss/customerreviews/page=9/id=497799835/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=10/id=497799835/sortby=mostrecent/json")!,
            next: URL(string: "https://itunes.apple.com/cn/rss/customerreviews/page=10/id=497799835/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=10/id=497799835/sortby=mostrecent/json")!)
        XCTAssertEqual(value.links, expectedLinks)
    }

    func test_fetchPublisher_withInvalidRating_returnsValidData() throws {
        let mockData = try TestData.json(fileName: "invalid_rating")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        var receivedValue: Feed?
        let exp = expectation(description: "Response error")
        let sub = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1))
            .sink { completion in
                if case .finished = completion {
                    exp.fulfill()
                }
            } receiveValue: { feed in
                receivedValue = feed
            }

        waitForExpectations(timeout: 1)
        XCTAssertNotNil(receivedValue)
        XCTAssertEqual(receivedValue?.entries.count ?? 0, 0)
        sub.cancel()
    }

    func test_fetchPublisher_withNoReviews_returnsValidData() throws {
        let mockData = try TestData.json(fileName: "1510826067_gb_2")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        var receivedValue: Feed?
        let exp = expectation(description: "Response error")
        let sub = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1))
            .sink { completion in
                if case .finished = completion {
                    exp.fulfill()
                }
            } receiveValue: { feed in
                receivedValue = feed
            }

        waitForExpectations(timeout: 1)
        XCTAssertNotNil(receivedValue)
        XCTAssertEqual(receivedValue?.entries.count ?? 0, 0)
        sub.cancel()
    }

    func test_fetchPublisher_withInvalidEntryAuthor_returnsValidData() throws {
        let mockData = try TestData.json(fileName: "invalid_entry_author_uri")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        var receivedValue: Feed?
        let exp = expectation(description: "Response error")
        let sub = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1))
            .sink { completion in
                if case .finished = completion {
                    exp.fulfill()
                }
            } receiveValue: { feed in
                receivedValue = feed
            }

        waitForExpectations(timeout: 1)
        XCTAssertNotNil(receivedValue)
        XCTAssertEqual(receivedValue?.entries.count ?? 0, 1)
        sub.cancel()
    }

    // MARK: Pages

    func test_fetchPublisher_firstPageWithNoNextPage_setsPageProperties() throws {
        let mockData = try TestData.json(fileName: "1510826067_gb_1")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        var receivedValue: Feed?
        let exp = expectation(description: "Response error")
        let sub = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1))
            .sink { completion in
                if case .finished = completion {
                    exp.fulfill()
                }
            } receiveValue: { feed in
                receivedValue = feed
            }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedValue?.currentPage, try Page(appID: 1510826067, territory: .GB, page: 1))
        XCTAssertEqual(receivedValue?.firstPage, try Page(appID: 1510826067, territory: .GB, page: 1))
        XCTAssertEqual(receivedValue?.lastPage, try Page(appID: 1510826067, territory: .GB, page: 1))
        XCTAssertNil(receivedValue?.previousPage)
        XCTAssertNil(receivedValue?.nextPage)
        sub.cancel()
    }

    func test_fetchPublisher_emptyPage_setsPageProperties() throws {
        let mockData = try TestData.json(fileName: "1510826067_gb_2")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        var receivedValue: Feed?
        let exp = expectation(description: "Response error")
        let sub = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1))
            .sink { completion in
                if case .finished = completion {
                    exp.fulfill()
                }
            } receiveValue: { feed in
                receivedValue = feed
            }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedValue?.currentPage, try Page(appID: 1510826067, territory: .GB, page: 2))
        XCTAssertEqual(receivedValue?.firstPage, try Page(appID: 1510826067, territory: .GB, page: 1))
        XCTAssertEqual(receivedValue?.lastPage, try Page(appID: 1510826067, territory: .GB, page: 1))
        XCTAssertEqual(receivedValue?.previousPage, try Page(appID: 1510826067, territory: .GB, page: 1))
        XCTAssertNil(receivedValue?.nextPage)
        sub.cancel()
    }

    func test_fetchPublisher_lastPage_setsPageProperties() throws {
        let mockData = try TestData.json(fileName: "497799835_cn_10")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        var receivedValue: Feed?
        let exp = expectation(description: "Response error")
        let sub = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1))
            .sink { completion in
                if case .finished = completion {
                    exp.fulfill()
                }
            } receiveValue: { feed in
                receivedValue = feed
            }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedValue?.currentPage, try Page(appID: 497799835, territory: .CN, page: 10))
        XCTAssertEqual(receivedValue?.firstPage, try Page(appID: 497799835, territory: .CN, page: 1))
        XCTAssertEqual(receivedValue?.lastPage, try Page(appID: 497799835, territory: .CN, page: 10))
        XCTAssertEqual(receivedValue?.previousPage, try Page(appID: 497799835, territory: .CN, page: 9))
        XCTAssertNil(receivedValue?.nextPage)
        sub.cancel()
    }

    func test_fetchPublisher_middlePage_setsPageProperties() throws {
        let mockData = try TestData.json(fileName: "497799835_cn_5")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        var receivedValue: Feed?
        let exp = expectation(description: "Response error")
        let sub = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1))
            .sink { completion in
                if case .finished = completion {
                    exp.fulfill()
                }
            } receiveValue: { feed in
                receivedValue = feed
            }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedValue?.currentPage, try Page(appID: 497799835, territory: .CN, page: 5))
        XCTAssertEqual(receivedValue?.firstPage, try Page(appID: 497799835, territory: .CN, page: 1))
        XCTAssertEqual(receivedValue?.lastPage, try Page(appID: 497799835, territory: .CN, page: 10))
        XCTAssertEqual(receivedValue?.previousPage, try Page(appID: 497799835, territory: .CN, page: 4))
        XCTAssertEqual(receivedValue?.nextPage, try Page(appID: 497799835, territory: .CN, page: 6))
        sub.cancel()
    }
    #endif

    // MARK: - Fetch with URLSessionDataTask

    // MARK: Errors

    func test_fetchDataTask_withInvalidHTTPCode_returnsInvalidHTTPResponseStatusError() throws {
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(statusCode: 500, data: Data()))

        let exp = expectation(description: "Response error")
        let task = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1)) { completion in
            if case .failure(let error) = completion,
               case .invalidHTTPResponseStatus(code: let code) = error,
               code == 500 {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
        task?.cancel()
    }

    func test_fetchDataTask_withNonHTTPResponse_returnsInvalidResponseError() throws {
        MockURLProtocol.mockResponse = .nonHTTPURLResponse

        let exp = expectation(description: "Response error")
        let task = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1)) { completion in
            if case .failure(let error) = completion,
               case .invalidResponse = error {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
        task?.cancel()
    }

    func test_fetchDataTask_withInvalidJSON_returnsJsonDecoderError() throws {
        let mockData = try TestData.json(fileName: "555731861_us_11")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        let exp = expectation(description: "Response error")
        let task = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1)) { completion in
            if case .failure(let error) = completion,
               case .jsonDecoder = error {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
        task?.cancel()
    }

    func test_fetchDataTask_withNoResponse_returnsInvalidResponseError() throws {
        MockURLProtocol.mockResponse = .none

        let exp = expectation(description: "Response error")
        let task = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1)) { completion in
            if case .failure(let error) = completion,
               case .invalidResponse = error {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
        task?.cancel()
    }

    func test_fetchDataTask_withError_returnsNetworkError() throws {
        MockURLProtocol.mockResponse = .error(URLError(.networkConnectionLost))

        var receivedUnderlyingError: Error?
        let exp = expectation(description: "Response error")
        let task = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1)) { completion in
            if case .failure(let error) = completion,
               case .networkError(let returnedError) = error {
                receivedUnderlyingError = returnedError
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
        XCTAssertEqual((receivedUnderlyingError as? URLError)?.code, URLError.Code.networkConnectionLost)
        task?.cancel()
    }

    func test_fetchDataTask_withInvalidFeedAuthorUri_returnsInvalidDataError() throws {
        let mockData = try TestData.json(fileName: "invalid_feed_author_uri")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        let exp = expectation(description: "Response error")
        let task = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1)) { completion in
            if case .failure(let error) = completion,
               case .invalidData = error {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
        task?.cancel()
    }

    func test_fetchDataTask_withInvalidLinks_returnsInvalidDataError() throws {
        let mockData = try TestData.json(fileName: "invalid_links")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        let exp = expectation(description: "Response error")
        let task = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1)) { completion in
            if case .failure(let error) = completion,
               case .invalidData = error {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
        task?.cancel()
    }

    // MARK: Success

    func test_fetchDataTask_withValidContent_returnsValidData() throws {
        let mockData = try TestData.json(fileName: "497799835_cn_10")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        var receivedValue: Feed?
        let exp = expectation(description: "Response success")
        let task = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1)) { completion in
            if case .success(let feed) = completion {
                receivedValue = feed
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
        task?.cancel()
        let value = try XCTUnwrap(receivedValue)
        XCTAssertEqual(value.entries.count, 50)
        XCTAssertEqual(value.author, Feed.Author(
                        name: "iTunes Store",
                        uri: URL(string: "http://www.apple.com/uk/itunes/")!)
        )
        XCTAssertEqual(value.entries.first, Feed.Entry(
                        author: Feed.Author(name: "lxzyzwoout", uri: URL(string: "https://itunes.apple.com/cn/reviews/id552914365?l=en")!),
                        appVersion: "12.0",
                        rating: 1,
                        id: "6455612413",
                        title: "越来越烂",
                        description: "其他的工具都是越开发越好用，就Xcode例外，越开发越难用",
                        voteCount: 2,
                        voteSum: 1,
                        territory: .CN,
                        appID: 497799835))
        XCTAssertEqual(value.title, "iTunes Store: Customer Reviews")
        XCTAssertEqual(value.rights, "Copyright 2008 Apple Inc.")
        // 2021-01-30T12:52:46-07:00
        let expectedDate = DateComponents(calendar: .current, timeZone: TimeZone(secondsFromGMT: -7 * 60 * 60), year: 2021, month: 1, day: 30, hour: 12, minute: 52, second: 46).date
        XCTAssertEqual(value.updated, expectedDate)
        let expectedLinks = Feed.Links(
            alternate: URL(string: "https://apps.apple.com/WebObjects/MZStore.woa/wa/viewGrouping?cc=cn&id=29099&l=en")!,
            current: URL(string: "https://itunes.apple.com/rss/customerreviews/page=10/id=497799835/sortby=mostrecent/json?l=en&cc=cn")!,
            first: URL(string: "https://itunes.apple.com/cn/rss/customerreviews/page=1/id=497799835/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=10/id=497799835/sortby=mostrecent/json")!,
            last: URL(string: "https://itunes.apple.com/cn/rss/customerreviews/page=10/id=497799835/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=10/id=497799835/sortby=mostrecent/json")!,
            previous: URL(string: "https://itunes.apple.com/cn/rss/customerreviews/page=9/id=497799835/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=10/id=497799835/sortby=mostrecent/json")!,
            next: URL(string: "https://itunes.apple.com/cn/rss/customerreviews/page=10/id=497799835/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=10/id=497799835/sortby=mostrecent/json")!)
        XCTAssertEqual(value.links, expectedLinks)
    }

    func test_fetchDataTask_withInvalidRating_returnsValidData() throws {
        let mockData = try TestData.json(fileName: "invalid_rating")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        var receivedValue: Feed?
        let exp = expectation(description: "Response error")
        let task = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1)) { completion in
            if case .success(let feed) = completion {
                receivedValue = feed
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(receivedValue)
        XCTAssertEqual(receivedValue?.entries.count ?? 0, 0)
        task?.cancel()
    }

    func test_fetchDataTask_withNoReviews_returnsValidData() throws {
        let mockData = try TestData.json(fileName: "1510826067_gb_2")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        var receivedValue: Feed?
        let exp = expectation(description: "Response error")
        let task = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1)) { completion in
            if case .success(let feed) = completion {
                receivedValue = feed
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(receivedValue)
        XCTAssertEqual(receivedValue?.entries.count ?? 0, 0)
        task?.cancel()
    }

    func test_fetchDataTask_withInvalidEntryAuthor_returnsValidData() throws {
        let mockData = try TestData.json(fileName: "invalid_entry_author_uri")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        var receivedValue: Feed?
        let exp = expectation(description: "Response error")
        let task = sut.fetch(page: try Page(appID: 1, territory: .GB, page: 1)) { completion in
            if case .success(let feed) = completion {
                receivedValue = feed
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(receivedValue)
        XCTAssertEqual(receivedValue?.entries.count ?? 0, 1)
        task?.cancel()
    }
}
