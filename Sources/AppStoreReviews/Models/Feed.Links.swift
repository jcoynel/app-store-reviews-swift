import Foundation

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

extension Feed.Links: Equatable {}
extension Feed.Links: Codable {}
