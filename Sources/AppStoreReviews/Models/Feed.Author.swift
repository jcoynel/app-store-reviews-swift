import Foundation

extension Feed {
    /// Representation of a feed author.
    public struct Author {
        /// The name of the author.
        public let name: String
        /// The link to the author.
        public let uri: URL
    }
}

extension Feed.Author: Equatable {}
extension Feed.Author: Codable {}
