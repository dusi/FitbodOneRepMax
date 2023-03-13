import XCTest
@testable import OneRepMax

final class BundleExtensionTests: XCTestCase {
    func testSample1() {
        let sut = Bundle.main.sample1
        XCTAssertEqual(sut?.lastPathComponent, "sample1.txt")
    }
}
