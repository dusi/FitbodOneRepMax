import XCTest
@testable import OneRepMax

final class BundleExtensionTests: XCTestCase {
    func testSampleURL() {
        let sut = Bundle.main.sample
        XCTAssertEqual(sut?.lastPathComponent, "sample.txt")
    }
    
    func testEmptyURL() {
        let sut = Bundle.main.empty
        XCTAssertEqual(sut?.lastPathComponent, "empty.txt")
    }
    
    func testInvalidURL() {
        let sut = Bundle.main.invalid
        XCTAssertNil(sut)
    }
}
