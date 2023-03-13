import XCTest
@testable import OneRepMax

final class ConstantsTests: XCTestCase {
    func testConstants() {
        let sut = Constants.weightIncrementsDescending
        XCTAssertEqual(sut.count, 6)
        XCTAssertEqual(sut[0], 45.0)
        XCTAssertEqual(sut[1], 35.0)
        XCTAssertEqual(sut[2], 25.0)
        XCTAssertEqual(sut[3], 10.0)
        XCTAssertEqual(sut[4], 5.0)
        XCTAssertEqual(sut[5], 2.5)
    }
}
