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
            personalBestExercise: .best,
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
    
    func testPersonalBestExercise() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax)
        XCTAssertEqual(sut.personalBestExercise, .best)
    }
    
    func testMostRecentOrSelectedExercise() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax)
        XCTAssertNil(sut.selectedExercise)
        XCTAssertEqual(sut.mostRecentOrSelectedExercise, sut.oneRepMax.lastExercise)
        
        let expectedExercise = Exercise.mock(name: "Deadlift", date: Date(), sets: 10, weight: 100)
        
        sut.selectedExercise = expectedExercise
        XCTAssertNotNil(sut.selectedExercise)
        XCTAssertEqual(sut.mostRecentOrSelectedExercise, expectedExercise)
    }
    
    func testShowsMostRecentExercise() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax)
        XCTAssertTrue(sut.showsMostRecentExercise)
        
        sut.selectedExercise = .mock
        XCTAssertFalse(sut.showsMostRecentExercise)
    }
    
    func testFooterForegroundColor() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax)
        XCTAssertEqual(sut.footerForegroundColor, .primary)
        
        sut.selectedExercise = .mock
        XCTAssertEqual(sut.footerForegroundColor, OneRepMaxDetailModel.Defaults.Style.selectionColor)
    }
    
    func testChartGestureDidChange() {
        let sut = OneRepMaxDetailModel(oneRepMax: mockOneRepMax)
        // No selection by default
        XCTAssertNil(sut.selectedExercise)
        // User selects the first date
        sut.chartGestureDidChange(with: sut.exercises.first!.date)
        XCTAssertEqual(sut.selectedExercise, sut.exercises.first)
        // User selects the last date
        sut.chartGestureDidChange(with: sut.exercises.last!.date)
        XCTAssertEqual(sut.selectedExercise, sut.exercises.last)
        // User interaction ends
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
