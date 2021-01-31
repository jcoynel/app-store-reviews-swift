import Foundation
import OSLog

extension URL {
    /// Create an App Store reviews page URL for the provided page.
    /// - Parameter page: The reviews page.
    ///
    /// Returns `nil` if a `URL` cannot be formed with the provided parameters.
    /// Example URL: https://itunes.apple.com/rss/customerreviews/page=1/id=1510826067/sortby=mostrecent/json?l=en&cc=gb
    public init?(_ page: Page) {
        guard page.appID > 0 else {
            Logger().error("Error creating reviews page URL: appID must be greater than 0.")
            return nil
        }
        guard page.page > 0 else {
            Logger().error("Error creating reviews page URL: appID must be greater than 0.")
            return nil
        }

        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/rss/customerreviews/page=\(page.page)/id=\(page.appID)/sortby=mostrecent/json"
        components.queryItems = [
            URLQueryItem(name: "l", value: "en"),
            URLQueryItem(name: "cc", value: page.territory.rawValue.lowercased())
        ]

        guard let url = components.url else {
            Logger().error("Error creating reviews page URL: failed to get url from components.")
            return nil
        }
        self = url
    }
}
