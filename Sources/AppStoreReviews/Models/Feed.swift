import Foundation

public struct Feed {
    public let author: Author
    public let entries: [Entry]
}

extension Feed: Equatable {}
extension Feed: Codable {}
