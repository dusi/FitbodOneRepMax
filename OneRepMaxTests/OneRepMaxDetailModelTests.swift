import XCTest
@testable import OneRepMax

final class OneRepMaxDetailModelTests: XCTestCase {
    var mockExercises: [Exercise]!
    var mockOneRepMax: OneRepMax!
    
    override func setUp() {
        super.setUp()
        
        mockExercises = [Int](1...100).map {
            Exercise(
                date: Date(timeIntervalSinceReferenceDate: TimeInterval($0 * 86_400)),
                name: "Exercise + \($0)",
                reps: 10,
                sets: 0,
                weight: 100 + $0
            )
        }
        mockOneRepMax = OneRepMax(
            exercises: mockExercises,
            name: "Deadlift",
            latestOneRepMax: 100
        )
    }
    
    func testExercisesAreLimitedTo31Elements() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax)
        XCTAssertEqual(sut.oneRepMax.name, "Deadlift")
        XCTAssertEqual(sut.oneRepMax.exercises.count, 100)
        XCTAssertEqual(sut.exercises.count, 31)
    }
    
    func testMinValue() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax)
        XCTAssertEqual(sut.minValue, 226.66666666666666)
    }
    
    func testMaxValue() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax)
        XCTAssertEqual(sut.minValue, 226.66666666666666)
    }
    
    func testYAxisMinValue() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax)
        XCTAssertEqual(sut.yAxisMinValue, 221.66666666666666)
    }
    
    func testYAxisMaxValue() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax)
        XCTAssertEqual(sut.yAxisMaxValue, 271.66666666666663)
    }
}
