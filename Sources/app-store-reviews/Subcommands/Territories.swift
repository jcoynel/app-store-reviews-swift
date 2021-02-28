import Foundation
import ArgumentParser
import AppStoreReviews

/// Encapsulates `territories` command behavior.
struct Territories: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Print the list of territories reviews can be fetched for."
    )

    func run() throws {
        AppStoreReviews.Territory.allCases.forEach { territory in
            /* e.g.
             ...
             TON Tonga
             TR  Turkey
             ...
             */
            print("\(territory.isoCode.padding(toLength: 3, withPad: " ", startingAt: 0)) \(territory.name)")
        }
    }
}
