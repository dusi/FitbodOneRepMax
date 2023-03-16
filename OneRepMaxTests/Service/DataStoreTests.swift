import XCTest
@testable import OneRepMax

final class DataStoreTests:XCTestCase {
    func testExercises() async throws {
        var mockParser = MockParser()
        mockParser.mockExercises = [
            .mock
        ]
        let sut: DataStoreInterface = DataStore(parser: mockParser)
        let exercises = try await sut.exercises
        XCTAssertEqual(exercises.count, 1)
    }
}

// MARK: - Mocks

struct MockParser: ParserInterface {
    var mockExercises: [Exercise]?
    func parseExercises(from input: String) async throws -> [Exercise] {
        if let mockExercises {
            return mockExercises
        }
        return []
    }
}
