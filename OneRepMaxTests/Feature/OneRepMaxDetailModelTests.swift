import Charts
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
            lastExercise: .mock
        )
    }
    
    func testSelectedExercise_Is_Nil_By_Default() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax)
        XCTAssertNil(sut.selectedExercise)
    }
    
    func testExercises_Are_Limited_To_31_Elements_On_Phone_Devices() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax, userInterfaceIdiom: .phone)
        XCTAssertEqual(sut.oneRepMax.name, "Deadlift")
        XCTAssertEqual(sut.oneRepMax.exercises.count, 100)
        XCTAssertEqual(sut.exercises.count, 31)
    }
    
    func testExercises_Are_Limited_To_93_Elements_On_Pad_Devices() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax, userInterfaceIdiom: .pad)
        XCTAssertEqual(sut.oneRepMax.name, "Deadlift")
        XCTAssertEqual(sut.oneRepMax.exercises.count, 100)
        XCTAssertEqual(sut.exercises.count, 93)
    }
    
    func testMinValue() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax, userInterfaceIdiom: .phone)
        XCTAssertEqual(sut.minValue, 226.66666666666666)
    }
    
    func testMaxValue() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax, userInterfaceIdiom: .phone)
        XCTAssertEqual(sut.minValue, 226.66666666666666)
    }
    
    func testYAxisMinValue() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax, userInterfaceIdiom: .phone)
        XCTAssertEqual(sut.yAxisMinValue, 221.66666666666666)
    }
    
    func testYAxisMaxValue() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax, userInterfaceIdiom: .phone)
        XCTAssertEqual(sut.yAxisMaxValue, 271.66666666666663)
    }
    
    func testChartGestureDidChange() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax)
        XCTAssertNil(sut.selectedExercise)
        sut.chartGestureDidChange(with: sut.exercises.first!.date)
        XCTAssertEqual(sut.selectedExercise, sut.exercises.first)
        sut.chartGestureDidChange(with: sut.exercises.last!.date)
        XCTAssertEqual(sut.selectedExercise, sut.exercises.last)
        sut.chartGestureDidEnd()
        XCTAssertNil(sut.selectedExercise)
    }
    
    func testChartGestureDidEnd() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax)
        sut.selectedExercise = .mock
        XCTAssertNotNil(sut.selectedExercise)
        sut.chartGestureDidEnd()
        XCTAssertNil(sut.selectedExercise)
    }
}
