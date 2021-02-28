import ArgumentParser
import AppStoreReviews

/// Encapsulates `--version` flag behavior.
struct VersionOptions: ParsableArguments {
    @Flag(name: .shortAndLong, help: "Print the version and exit")
    var version: Bool = false

    func validate() throws {
        if version {
            print(AppStoreReviews.version)
            throw ExitCode.success
        }
    }
}
