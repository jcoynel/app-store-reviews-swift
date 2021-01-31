import Foundation
import Combine

/// Provides functionality to download App Store reviews data.
public struct Downloader {
    typealias Publisher = AnyPublisher<Feed, Downloader.Error>

    private let urlSession: URLSession

    /// Initialize with a URLSession.
    /// - Parameter urlSession: The URLSession to use to perform downloads.
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    /// Fetch the content of the page specified.
    /// - Parameter page: The page to download.
    /// - Returns: A publisher.
    func fetch(page: Page) -> Publisher {
        guard let url = URL(page) else {
            return Fail<Feed, Downloader.Error>(error: Downloader.Error.invalidURL)
                .eraseToAnyPublisher()
        }
        return urlSession.dataTaskPublisher(for: url)
            .tryMap { (output: (data: Data, response: URLResponse)) -> Feed in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw Downloader.Error.invalidResponse
                }
                guard httpResponse.statusCode == 200 else {
                    throw Downloader.Error.invalidHTTPResponseStatus(code: httpResponse.statusCode)
                }

                let decodableFeed: DecodableFeed.CustomerReviews
                do {
                    decodableFeed = try JSONDecoder().decode(DecodableFeed.CustomerReviews.self, from: output.data)
                } catch {
                    throw Downloader.Error.jsonDecoder(underlyingError: error)
                }

                guard let feed = Feed(decodableFeed.feed) else {
                    throw Downloader.Error.invalidData
                }

                return feed
            }
            .mapError { ($0 as? Downloader.Error) ?? Downloader.Error.noResponseData }
            .eraseToAnyPublisher()
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
        case noResponseData
    }
}
