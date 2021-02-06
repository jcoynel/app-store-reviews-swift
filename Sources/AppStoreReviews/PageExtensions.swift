import Foundation
import OSLog

extension Page {
    /// Initialize a Page from a url.
    ///
    /// - Parameter url: The URL to initialize from.
    /// - Returns: A new Page instance from the provided url. `nil` if the url couldn't be parsed.
    ///
    /// Example input:
    /// * https://itunes.apple.com/rss/customerreviews/page=10/id=497799835/sortby=mostrecent/json?l=en&cc=cn
    /// * https://itunes.apple.com/fr/rss/customerreviews/page=1/id=1/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=1/id=1/sortby=mostrecent/json
    /// * https://itunes.apple.com/fr/rss/customerreviews/page=2/id=1/sortby=mostrecent/xml?l=en&urlDesc=/customerreviews/page=1/id=1/sortby=mostrecent/json
    public init?(_ url: URL) {
        // When parsing the input url, urlDesc should be ignored.
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        do {
            if let page = Self.pageWithPath(path: components.path) {
                try self.init(appID: page.appID, territory: page.territory, page: page.page)
            } else if let code = components.queryItems?.first(where: { item in item.name == "cc" })?.value,
                      let territory = Territory(rawValue: code.uppercased()),
                      let page = Self.intValue(in: components.path, key: .page),
                      let appID = Self.intValue(in: components.path, key: .id) {
                try self.init(appID: appID, territory: territory, page: page)
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}

// MARK: - Helpers

private extension Page {
    static func pageWithPath(path: String) -> Page? {
        guard let code = path.split(separator: "/").first,
              let territory = Territory(rawValue: code.uppercased()) else {
            Logger().error("Failed to initialize Territory with code: \(path)")
            return nil
        }

        guard let page = Self.intValue(in: path, key: .page),
              let appID = Self.intValue(in: path, key: .id) else {
            return nil
        }

        return try? Page(appID: appID, territory: territory, page: page)
    }

    static func intValue(in path: String, key: Keys) -> Int? {
        // e.g. path /cn/rss/customerreviews/page=10/id=497799835/sortby=mostrecent/xml
        let items = path.split(separator: "/")
        guard let item = items.first(where: { $0.hasPrefix("\(key.rawValue)=") }),
              let stringValue = item.split(separator: "=").last,
              let intValue = Int(stringValue) else {
            return nil
        }
        return intValue
    }

    enum Keys: String {
        case id, page
    }
}
