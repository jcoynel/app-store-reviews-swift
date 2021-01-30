import Foundation
import OSLog

public extension URL {
    /// Create an App Store reviews page URL with app ID, territory and page number.
    ///
    /// - Parameters:
    ///   - appID: The App Store app ID. Must be greater than 0.
    ///   - territory: The App Store territory.
    ///   - page: The reviews page number. Must be greater than 0.
    ///
    /// Returns `nil` if a `URL` cannot be formed with the provided parameters.
    /// Example URL: https://itunes.apple.com/rss/customerreviews/page=1/id=1510826067/sortby=mostrecent/json?l=en&cc=gb
    init?(appID: Int, territory: Territory, page: Int) {
        guard appID > 0 else {
            Logger().error("Error creating reviews page URL: appID must be greater than 0.")
            return nil
        }
        guard page > 0 else {
            Logger().error("Error creating reviews page URL: appID must be greater than 0.")
            return nil
        }

        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/rss/customerreviews/page=\(page)/id=\(appID)/sortby=mostrecent/json"
        components.queryItems = [
            URLQueryItem(name: "l", value: "en"),
            URLQueryItem(name: "cc", value: territory.rawValue.lowercased())
        ]

        guard let url = components.url else {
            Logger().error("Error creating reviews page URL: failed to get url from components.")
            return nil
        }
        self = url
    }
}
