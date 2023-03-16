import XCTest
@testable import OneRepMax

final class DateFormatterExtensionsTests: XCTestCase {
    func testInputFormatter() {
        let sut = DateFormatter.input()
        XCTAssertEqual(sut.string(from: Date(timeIntervalSinceReferenceDate: 1)), "Dec 31 2000")
    }
    
    func testDefaultFormatter() {
        let sut = DateFormatter.default()
        XCTAssertEqual(sut.string(from: Date(timeIntervalSinceReferenceDate: 1)), "December 31, 2000")
    }
}
