import XCTest
@testable import AppStoreReviews

final class TerritoryTests: XCTestCase {
    func test_territory_isoCode_isUppercase() {
        let validCodeSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        Territory.allCases.forEach { territory in
            XCTAssertNil(territory.isoCode.rangeOfCharacter(from: validCodeSet.inverted), "\(territory.isoCode) countains unexpected characters.")
        }
    }

    func test_territory_isoCodeLength_isTwoOrThree() {
        Territory.allCases.forEach { territory in
            XCTAssertGreaterThanOrEqual(territory.isoCode.count, 2)
            XCTAssertLessThanOrEqual(territory.isoCode.count, 3)
        }
    }

    func test_territory_name_isNotEmpty() {
        Territory.allCases.forEach { territory in
            XCTAssertFalse(territory.name.isEmpty)
        }
    }
}
