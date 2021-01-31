import Foundation

extension Feed {
    public struct Author {
        public let name: String
        public let uri: URL
    }
}

extension Feed.Author: Equatable {}
extension Feed.Author: Codable {}
