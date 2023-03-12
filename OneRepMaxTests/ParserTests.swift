@testable import OneRepMax
import XCTest

final class ParserTests: XCTestCase {
    func testParseExercises() async throws {
        let sut: ParserInterface = Parser()
        let exercises = try await sut.parseExercises(from: "")
        XCTAssertEqual(exercises.count, 2)
        XCTAssertEqual(exercises[0].name, "Bench Press")
        XCTAssertEqual(exercises[1].name, "Deadlift")
    }
}
