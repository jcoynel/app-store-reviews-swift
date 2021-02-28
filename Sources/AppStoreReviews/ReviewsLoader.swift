import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Provides functionality to download all App Store reviews data.
///
/// - Note: Use `FeedLoader` instead of `ReviewsLoader` if you want more control, such as
/// loading a specific reviews page.
public final class ReviewsLoader {
    public typealias Completion = (Result<[Feed.Entry], ReviewsLoader.Error>) -> Void

    private let urlSession: URLSession
    private let downloader: FeedLoader
    private var task: URLSessionDataTask?

    private var fetchedReviews = [Feed.Entry]()

    /// Initialize with a URLSession.
    /// - Parameter urlSession: The URLSession to use to perform downloads.
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
        self.downloader = FeedLoader(urlSession: urlSession)
    }

    /// Fetch all reviews for the provided appID and territory.
    /// - Parameters:
    ///   - appID: The ID of the app. e.g. 1510826067.
    ///   - territory: The territory.
    ///   - completion: The completion handler called with a result.
    public func fetchAll(appID: Int, territory: Territory, completion: @escaping Completion) {
        clearDownloads()
        guard let firstPage = try? Page(appID: appID, territory: territory, page: 1) else {
            completion(.failure(.generic))
            return
        }

        fetch(page: firstPage, completion: completion)
    }
}

// MARK: - Helpers

extension ReviewsLoader {
    private func fetch(page: Page, completion: @escaping Completion) {
        downloader.fetch(page: page) { [weak self] result in
            guard let self = self else {
                completion(.failure(.generic))
                return
            }
            switch result {
            case .success(let feed):
                self.fetchedReviews.append(contentsOf: feed.entries)
                if let nextPage = feed.nextPage {
                    self.fetch(page: nextPage, completion: completion)
                } else {
                    completion(.success(self.fetchedReviews))
                }
            case .failure(let error):
                completion(.failure(.feedLoaderError(underlyingError: error)))
            }
        }
    }

    private func clearDownloads() {
        task?.cancel()
        fetchedReviews.removeAll()
    }
}

// MARK: - Errors

extension ReviewsLoader {
    /// Defines errors that can occur when using `ReviewsLoader`.
    public enum Error: Swift.Error {
        case generic
        case feedLoaderError(underlyingError: FeedLoader.Error)
    }
}
