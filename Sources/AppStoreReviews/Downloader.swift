import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(Combine)
import Combine
#endif

/// Provides functionality to download App Store reviews data.
public struct Downloader {
    public typealias Completion = (Result<Feed, Downloader.Error>) -> Void

    private let urlSession: URLSession

    /// Initialize with a URLSession.
    /// - Parameter urlSession: The URLSession to use to perform downloads.
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    #if canImport(Combine)
    public typealias Publisher = AnyPublisher<Feed, Downloader.Error>

    /// Fetch the content of the page specified.
    /// - Parameter page: The page to download.
    /// - Returns: A publisher.
    public func fetch(page: Page) -> Publisher {
        guard let url = URL(page) else {
            return Fail<Feed, Downloader.Error>(error: Downloader.Error.invalidURL)
                .eraseToAnyPublisher()
        }
        return urlSession.dataTaskPublisher(for: url)
            .tryMap { (output: (data: Data, response: URLResponse)) -> Feed in
                try validate(response: output.response)
                return try decode(feedData: output.data)
            }
            .mapError { ($0 as? Downloader.Error) ?? .networkError(underlyingError: $0) }
            .eraseToAnyPublisher()
    }
    #endif

    /// Fetch the content of the page specified.
    /// - Parameters:
    ///   - page: The page to download.
    ///   - completion: The completion handler called with a result.
    /// - Returns: The `URLSessionDataTask` created to fetch the content, or `nil` in case of
    /// failure.
    public func fetch(page: Page, completion: @escaping Completion) -> URLSessionDataTask? {
        guard let url = URL(page) else {
            completion(.failure(.invalidURL))
            return nil
        }
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkError(underlyingError: error)))
                return
            }
            do {
                try validate(response: response)

                let feed = try decode(feedData: data)
                completion(.success(feed))
            } catch {
                completion(.failure(error as! Downloader.Error))
            }
        }
        task.resume()
        return task
    }
}

extension Downloader {
    private func validate(response: URLResponse?) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Downloader.Error.invalidResponse
        }
        guard httpResponse.statusCode == 200 else {
            throw Downloader.Error.invalidHTTPResponseStatus(code: httpResponse.statusCode)
        }
    }

    private func decode(feedData: Data?) throws -> Feed {
        guard let feedData = feedData else {
            throw Downloader.Error.invalidResponse
        }

        let decodableFeed: DecodableFeed.CustomerReviews
        do {
            decodableFeed = try JSONDecoder().decode(DecodableFeed.CustomerReviews.self, from: feedData)
        } catch {
            throw Downloader.Error.jsonDecoder(underlyingError: error)
        }

        guard let feed = Feed(decodableFeed.feed) else {
            throw Downloader.Error.invalidData
        }
        return feed
    }
}

extension Downloader {
    /// Defines errors that can occur when using `Downloader`.
    public enum Error: Swift.Error {
        case invalidURL
        case invalidResponse
        case invalidHTTPResponseStatus(code: Int)
        case jsonDecoder(underlyingError: Swift.Error)
        case invalidData
        case networkError(underlyingError: Swift.Error)
    }
}
