import XCTest
@testable import OneRepMax

final class BundleExtensionTests: XCTestCase {
    func testSampleUrl() {
        let sut = Bundle.main.sample
        XCTAssertEqual(sut?.lastPathComponent, "sample.txt")
    }
    
    func testEmptyUrl() {
        let sut = Bundle.main.empty
        XCTAssertEqual(sut?.lastPathComponent, "empty.txt")
    }
    
    func testInvalidUrl() {
        let sut = Bundle.main.invalid
        XCTAssertNil(sut)
    }
}
