import Foundation

struct TestData {
    enum Error: Swift.Error {
        case couldNotFindFile
    }

    static func json(fileName: String) throws -> Data {
        guard let path = Bundle.module.path(forResource: fileName, ofType: "json", inDirectory: "Resources") else {
            throw Error.couldNotFindFile
        }

        return try Data(contentsOf: URL(fileURLWithPath: path))
    }
}
