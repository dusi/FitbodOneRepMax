@testable import OneRepMax
import XCTest

final class ExerciseTests: XCTestCase {
    func testOneRepMax() {
        let sut = Exercise(date: Date(), name: "Back Squat", reps: 4, sets: 1, weight: 260)
        XCTAssertEqual(sut.oneRepMax, 283.6363636363636)
    }
}
