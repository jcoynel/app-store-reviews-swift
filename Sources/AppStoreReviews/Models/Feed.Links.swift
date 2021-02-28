import Foundation

extension Feed {
    /// Representation of the navigation links of a feed. All values are parsed from the feed without any
    /// transformation.
    public struct Links {
        /// The alternate url for current page of the feed.
        public let alternate: URL
        /// The current page of the feed.
        public let current: URL
        /// The first page of the feed.
        public let first: URL?
        /// The last page of the feed.
        public let last: URL?
        /// The previous page of the feed.
        public let previous: URL?
        /// The next page of the feed.
        public let next: URL?
    }
}

extension Feed.Links: Equatable {}
extension Feed.Links: Codable {}
