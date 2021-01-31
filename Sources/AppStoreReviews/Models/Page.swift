import Foundation

/// Representation of a customers reviews page.
public struct Page {
    /// The ID of the app.
    public let appID: Int
    /// The territory.
    public let territory: Territory
    /// The page number.
    public let page: Int

    /// Initialize page with provided parameters.
    /// - Parameters:
    ///   - appID: The ID of the app. e.g. 1510826067.
    ///   - territory: The territory.
    ///   - page: The page number.
    public init(appID: Int, territory: Territory, page: Int) {
        self.appID = appID
        self.territory = territory
        self.page = page
    }
}
