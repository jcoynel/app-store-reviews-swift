import Foundation
import ArgumentParser

enum Output {
    static func write<Value: Encodable>(_ data: Value, to file: String) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let json = try encoder.encode(data)
        let outputURL = URL(fileURLWithPath: file)
        try json.write(to: outputURL)
    }
}
