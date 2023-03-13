import XCTest
@testable import OneRepMax

final class DateFormatterExtensionsTests: XCTestCase {
    func testDefaultFormatter() {
        let sut = DateFormatter.default()
        XCTAssertNotNil(sut.date(from: "Mar 13 2023"))
    }
}
