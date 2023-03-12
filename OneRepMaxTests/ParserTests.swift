@testable import OneRepMax
import XCTest

final class ParserTests: XCTestCase {
    private let mockInput = """
    Oct 11 2020,Back Squat,1,6,245
    Oct 05 2020,Barbell Bench Press,1,2,225
    Oct 04 2020,Deadlift,1,10,45
    """
    
    func testParseExercises() async throws {
        let sut: ParserInterface = Parser(dateFormatter: DateFormatter.default())
        
        let exercises = try await sut.parseExercises(from: mockInput)
        XCTAssertEqual(exercises.count, 3)
        
        XCTAssertEqual(exercises[0].name, "Back Squat")
        XCTAssertEqual(exercises[0].reps, 6)
        XCTAssertEqual(exercises[0].sets, 1)
        XCTAssertEqual(exercises[0].weight, 245)
        
        XCTAssertEqual(exercises[1].name, "Barbell Bench Press")
        XCTAssertEqual(exercises[1].reps, 2)
        XCTAssertEqual(exercises[1].sets, 1)
        XCTAssertEqual(exercises[1].weight, 225)
        
        XCTAssertEqual(exercises[2].name, "Deadlift")
        XCTAssertEqual(exercises[2].reps, 10)
        XCTAssertEqual(exercises[2].sets, 1)
        XCTAssertEqual(exercises[2].weight, 45)
    }
}
