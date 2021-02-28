import XCTest
@testable import AppStoreReviews
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class ReviewsLoaderTests: XCTestCase {
    var sut: ReviewsLoader!
    var urlSession: URLSession!

    override func setUpWithError() throws {
        MockURLProtocol.clearTestData()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)

        sut = ReviewsLoader(urlSession: urlSession)
    }

    override func tearDownWithError() throws {
        urlSession.invalidateAndCancel()
        MockURLProtocol.clearTestData()
    }

    // MARK: - Success

    func test_reviewsLoader_withSinglePage_fetchesAllReviews() throws {
        let mockData = try TestData.json(fileName: "1510826067_gb_1")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        let exp = expectation(description: "Response success")
        sut.fetchAll(appID: 1510826067, territory: .GB) { result in
            switch result {
            case .success(let entries):
                XCTAssertEqual(entries.count, 4)
                exp.fulfill()
            case .failure:
                break
            }
        }

        waitForExpectations(timeout: 1)
    }

    func test_reviewsLoader_withMultiplePages_fetchesAllReviews() throws {
        let mockData1 = try TestData.json(fileName: "497799835_cn_5")
        let mockData2 = try TestData.json(fileName: "497799835_cn_10")
        let expectedUrl1 = URL(string: "https://itunes.apple.com/rss/customerreviews/page=1/id=497799835/sortby=mostrecent/json?l=en&cc=cn")!
        let expectedUrl2 = URL(string: "https://itunes.apple.com/rss/customerreviews/page=6/id=497799835/sortby=mostrecent/json?l=en&cc=cn")!
        MockURLProtocol.mockResponses = [
            expectedUrl1: .HTTPURLResponse(.init(data: mockData1)),
            expectedUrl2: .HTTPURLResponse(.init(data: mockData2)),
        ]

        let exp = expectation(description: "Response success")
        sut.fetchAll(appID: 497799835, territory: .CN) { result in
            switch result {
            case .success(let entries):
                XCTAssertEqual(entries.count, 100)
                XCTAssertEqual(entries.first?.id, "6668621742")
                XCTAssertEqual(entries.last?.id, "6436982592")
                exp.fulfill()
            case .failure:
                break
            }
        }

        waitForExpectations(timeout: 1)
    }

    func test_reviewsLoader_withEmptyPage_returnsEmptyReviews() throws {
        let mockData = try TestData.json(fileName: "1510826067_gb_2")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        let exp = expectation(description: "Response success")
        sut.fetchAll(appID: 1, territory: .GB) { result in
            switch result {
            case .success(let entries):
                XCTAssertEqual(entries.count, 0)
                exp.fulfill()
            case .failure:
                break
            }
        }

        waitForExpectations(timeout: 1)
    }

    // MARK: - Failure

    func test_reviewsLoader_withInvalidPage_returnsDownloaderError() throws {
        let mockData = try TestData.json(fileName: "555731861_us_11")
        MockURLProtocol.mockResponse = .HTTPURLResponse(.init(data: mockData))

        let exp = expectation(description: "Response failure")
        sut.fetchAll(appID: 1, territory: .GB) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                if case .downloaderError = error {
                    exp.fulfill()
                }
            }
        }

        waitForExpectations(timeout: 1)
    }
}
