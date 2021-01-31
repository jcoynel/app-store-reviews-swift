import Foundation

/// Utility to simplify loading test data.
struct TestData {
    enum Error: Swift.Error {
        case fileNotFound
    }

    /// Load JSON test data from specified file.
    /// - Parameter fileName: The name of the file to load, not including it's `.json` extension.
    /// - Throws: Error.fileNotFound if the specified file name cannot be found.
    /// - Returns: The data from the specified file.
    static func json(fileName: String) throws -> Data {
        guard let path = Bundle.module.path(forResource: fileName, ofType: "json", inDirectory: "TestData") else {
            throw Error.fileNotFound
        }

        return try Data(contentsOf: URL(fileURLWithPath: path))
    }
}
