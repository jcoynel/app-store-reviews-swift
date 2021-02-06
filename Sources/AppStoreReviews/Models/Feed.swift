import Foundation

public struct Feed {
    public let author: Author
    public let entries: [Entry]
    public let title: String
    public let rights: String
    public let updated: Date
    public let links: Links

    /// The current page of the feed.
    public let currentPage: Page
    /// The first page of the feed.
    public let firstPage: Page
    /// The last page of the feed.
    public let lastPage: Page
    /// The previous page of the feed, or `nil` if the current page is the first.
    public let previousPage: Page?
    /// The next page of the feed, or `nil` if the current page is the last.
    public let nextPage: Page?
}

extension Feed: Equatable {}
extension Feed: Codable {}
