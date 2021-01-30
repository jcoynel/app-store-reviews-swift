import XCTest
@testable import AppStoreReviews

final class TerritoryTests: XCTestCase {
    func testIsoCodeIsUppercase() {
        let validCodeSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        Territory.allCases.forEach { territory in
            XCTAssertNil(territory.isoCode.rangeOfCharacter(from: validCodeSet.inverted), "\(territory.isoCode) countains unexpected characters.")
        }
    }

    func testIsoCodeLengthIsTwoOrThree() {
        Territory.allCases.forEach { territory in
            XCTAssertGreaterThanOrEqual(territory.isoCode.count, 2)
            XCTAssertLessThanOrEqual(territory.isoCode.count, 3)
        }
    }

    func testNameIsNotEmpty() {
        Territory.allCases.forEach { territory in
            XCTAssertFalse(territory.name.isEmpty)
        }
    }

    static var allTests = [
        ("testIsoCodeIsUppercase", testIsoCodeIsUppercase),
        ("testIsoCodeLengthIsTwoOrThree", testIsoCodeLengthIsTwoOrThree),
        ("testNameIsNotEmpty", testNameIsNotEmpty),
    ]
}
