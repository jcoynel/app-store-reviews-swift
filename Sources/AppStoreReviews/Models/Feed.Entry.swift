import Foundation

extension Feed {
    public struct Entry {
        /// The author of the entry.
        public let author: Author
        /// The version of the app reviewed. e.g. 13.2.1
        public let appVersion: String
        /// The rating of the app from 1 to 5.
        public let rating: Int
        /// The ID of the entry.
        public let id: String
        /// The title of the entry.
        public let title: String
        /// The review text of the entry.
        public let description: String
        
        public let voteCount: Int
        public let voteSum: Int
    }
}

extension Feed.Entry: Equatable {}
extension Feed.Entry: Codable {}
