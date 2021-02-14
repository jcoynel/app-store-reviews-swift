import Foundation
import ArgumentParser
import AppStoreReviews
import Combine

// swift run AppStoreReviewsCLI 555731861 GB
struct Reviews: ParsableCommand {
    @Argument(help: "The ID of the app.")
    var appID: Int = 555731861

    @Argument(help: "App Store country or region.")
    var territory: Territory = .GB

    @Argument(help: "The page number.")
    var page: Int = 1

    @Argument(help: "The reviews file output.")
    var fileOutput: String = "reviews.json"

    private var fileOutputURL: URL {
        URL(fileURLWithPath: fileOutput)
    }

    func run() throws {
        let page = try Page(appID: appID, territory: territory, page: self.page)
        var receivedFeed: Feed?
        let cancellable = Downloader()
            .fetch(page: page)
            .sink { completion in
                switch completion {
                case .finished:
                    do {
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = .prettyPrinted
                        let json = try encoder.encode(receivedFeed)
                        try json.write(to: self.fileOutputURL)
                        Self.exit()
                    } catch {
                        Self.exit(withError: error)
                    }
                case .failure(let error):
                    Self.exit(withError: error)
                }
            } receiveValue: { feed in
                receivedFeed = feed
            }
        dispatchMain()
    }
}

extension Territory: ExpressibleByArgument {}
