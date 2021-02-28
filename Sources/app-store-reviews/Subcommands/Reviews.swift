import Foundation
import ArgumentParser
import AppStoreReviews

/// Encapsulates `reviews` command behavior.
struct Reviews: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Fetch all the reviews from the App Store Reviews feed for the provided app ID and territory."
    )

    @Argument(help: "The ID of the app.")
    var appID: Int

    @Argument(help: "App Store country or region.")
    var territory: Territory

    @Argument(help: "The reviews file output.")
    var fileOutput: String

    func run() throws {
        let loader = ReviewsLoader()
        loader.fetchAll(appID: appID, territory: territory) { result in
            switch result {
            case .success(let reviews):
                do {
                    try Output.write(reviews, to: fileOutput)
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
