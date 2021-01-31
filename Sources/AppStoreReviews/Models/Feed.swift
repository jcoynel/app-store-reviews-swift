import Foundation

public struct Feed {
    public let author: Author
    public let entries: [Entry]
    public let title: String
    public let rights: String
    public let updated: Date
}

extension Feed: Equatable {}
extension Feed: Codable {}
