import XCTest
@testable import OneRepMax

final class DoubleExtensionsTests: XCTestCase {
    func testRoundToNearest() {
        var sut: Double = 123.456_789
        XCTAssertEqual(sut.round(toNearest: 2.5), 122.5)
        sut = 124.123
        XCTAssertEqual(sut.round(toNearest: 2.5), 125)
        sut = 125.0
        XCTAssertEqual(sut.round(toNearest: 2.5), 125)
    }
}
