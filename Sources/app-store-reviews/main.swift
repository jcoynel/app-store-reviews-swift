import ArgumentParser

/// Collects the command line options that were passed to `app-store-reviews` and dispatches to the
/// appropriate subcommand.
struct AppStoreReviewsCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "app-store-reviews",
        abstract: "Fetch user reviews from the Apple App Stores.",
        subcommands: [
            Reviews.self,
            Page.self,
            Territories.self,
        ],
        defaultSubcommand: nil
    )

    @OptionGroup()
    var versionOptions: VersionOptions
}

AppStoreReviewsCommand.main()
