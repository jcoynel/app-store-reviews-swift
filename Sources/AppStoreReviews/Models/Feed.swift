import Foundation

public struct Feed {
    public let author: Author
    public let entries: [Entry]
    public let title: String
    public let rights: String
    public let updated: Date
    public let links: Links
}

extension Feed {
    public struct Links {
        public let alternate: URL
        public let current: URL
        public let first: URL
        public let last: URL
        public let previous: URL
        public let next: URL
    }
}

extension Feed: Equatable {}
extension Feed: Codable {}
extension Feed.Links: Equatable {}
extension Feed.Links: Codable {}
