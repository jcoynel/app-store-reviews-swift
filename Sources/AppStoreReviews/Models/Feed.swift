import Foundation

/// Representation of the reviews feed.
public struct Feed {
    /// The author of the feed.
    public let author: Author
    /// The entries of the feed.
    public let entries: [Entry]
    /// The title of the feed.
    public let title: String
    /// The copyright of the feed.
    public let rights: String
    /// The date the feed was last updated.
    public let updated: Date
    /// The links of the feed.
    ///
    /// - Note: Each link contains the raw value parsed from the feed. Use `currentPage`,
    /// `firstPage`, `lastPage`, `previousPage` and `nextPage` for standardised values.
    ///
    /// - Important: The url provided by the `Page` entities may not match those from `Links`.
    public let links: Links
    /// The current page of the feed.
    public let currentPage: Page
    /// The first page of the feed. `nil` when there are no reviews for the app in a given territory.
    public let firstPage: Page?
    /// The last page of the feed. `nil` when there are no reviews for the app in a given territory.
    public let lastPage: Page?
    /// The previous page of the feed, or `nil` if the current page is the first.
    public let previousPage: Page?
    /// The next page of the feed, or `nil` if the current page is the last.
    public let nextPage: Page?
    /// The territory of the feed.
    public var territory: Territory { currentPage.territory }
    /// The ID of the app.
    public var appID: Int { currentPage.appID }
}

extension Feed: Equatable {}
extension Feed: Codable {}
