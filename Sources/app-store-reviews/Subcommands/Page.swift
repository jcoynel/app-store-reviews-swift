import Foundation
import ArgumentParser
import AppStoreReviews

/// Encapsulates `page` command behavior.
struct Page: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Fetch the App Store Reviews feed page for the provided app ID, territory and page number."
    )

    @Argument(help: "The ID of the app.")
    var appID: Int

    @Argument(help: "App Store country or region.")
    var territory: Territory

    @Argument(help: "The page number.")
    var page: Int

    @Argument(help: "The reviews file output.")
    var fileOutput: String

    func run() throws {
        let pageToFetch = try AppStoreReviews.Page(appID: appID, territory: territory, page: page)

        let loader = FeedLoader()
        loader.fetch(page: pageToFetch) { result in
            switch result {
            case .success(let feed):
                do {
                    try Output.write(feed, to: fileOutput)
                    Self.exit()
                } catch {
                    Self.exit(withError: error)
                }
            case .failure(let error):
                Self.exit(withError: error)
            }
        }
        dispatchMain()
    }
}
