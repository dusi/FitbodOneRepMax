@testable import OneRepMax
import XCTest

final class DataProviderTests: XCTestCase {
    private var mockDataStore: MockDataStore!
    
    override func setUp() {
        super.setUp()
        
        mockDataStore = MockDataStore()
    }
    
    func testOneRepMaxes_When_Throws() async throws {
        mockDataStore.mockResult = .failure(MockError())
        
        let sut = DataProvider(dataStore: mockDataStore)
        
        do {
            let _ = try await sut.oneRepMaxes
            XCTFail("Expected to throw")
        } catch {
            XCTAssertNotNil(error as? MockError)
        }
    }
    
    func testOneRepMaxes_When_Empty() async throws {
        let sut = DataProvider(dataStore: mockDataStore)
        let oneRepMaxes = try await sut.oneRepMaxes
        XCTAssertEqual(oneRepMaxes.count, 0)
    }
    
    func testOneRepMaxes() async throws {
        mockDataStore.mockResult = .success([
            Exercise(date: Date(timeIntervalSinceReferenceDate: 1), name: "Back Squat", reps: 6, sets: 1, weight: 245),
            Exercise(date: Date(timeIntervalSinceReferenceDate: 1), name: "Back Squat", reps: 6, sets: 1, weight: 245),
            Exercise(date: Date(timeIntervalSinceReferenceDate: 2), name: "Bench Press", reps: 4, sets: 1, weight: 45),
            Exercise(date: Date(timeIntervalSinceReferenceDate: 2), name: "Bench Press", reps: 2, sets: 1, weight: 225),
            Exercise(date: Date(timeIntervalSinceReferenceDate: 3), name: "Back Squat", reps: 10, sets: 1, weight: 45),
            Exercise(date: Date(timeIntervalSinceReferenceDate: 3), name: "Back Squat", reps: 4, sets: 1, weight: 260),
            Exercise(date: Date(timeIntervalSinceReferenceDate: 4), name: "Deadlift", reps: 3, sets: 1, weight: 315),
            Exercise(date: Date(timeIntervalSinceReferenceDate: 4), name: "Deadlift", reps: 3, sets: 1, weight: 315),
            Exercise(date: Date(timeIntervalSinceReferenceDate: 5), name: "Biceps Curl", reps: 8, sets: 1, weight: 35),
            Exercise(date: Date(timeIntervalSinceReferenceDate: 5), name: "Biceps Curl", reps: 6, sets: 1, weight: 50),
            Exercise(date: Date(timeIntervalSinceReferenceDate: 6), name: "Biceps Curl", reps: 8, sets: 1, weight: 20),
            Exercise(date: Date(timeIntervalSinceReferenceDate: 6), name: "Biceps Curl", reps: 8, sets: 1, weight: 30),
            Exercise(date: Date(timeIntervalSinceReferenceDate: 7), name: "Biceps Curl", reps: 8, sets: 1, weight: 35),
            Exercise(date: Date(timeIntervalSinceReferenceDate: 7), name: "Biceps Curl", reps: 10, sets: 1, weight: 50),
        ])
        
        let sut = DataProvider(dataStore: mockDataStore)
        let oneRepMaxes = try await sut.oneRepMaxes
        
        XCTAssertEqual(oneRepMaxes.count, 4)
        
        XCTAssertEqual(oneRepMaxes[0].name, "Back Squat")
        XCTAssertEqual(oneRepMaxes[0].exercises.count, 2)
        XCTAssertEqual(oneRepMaxes[0].exercises[0].reps, 6)
        XCTAssertEqual(oneRepMaxes[0].exercises[0].weight, 245)
        XCTAssertEqual(oneRepMaxes[0].exercises[0].oneRepMax, 284.5161290322581)
        XCTAssertEqual(oneRepMaxes[0].exercises[1].reps, 4)
        XCTAssertEqual(oneRepMaxes[0].exercises[1].weight, 260)
        XCTAssertEqual(oneRepMaxes[0].exercises[1].oneRepMax, 283.6363636363636)

        XCTAssertEqual(oneRepMaxes[1].name, "Bench Press")
        XCTAssertEqual(oneRepMaxes[1].exercises.count, 1)
        XCTAssertEqual(oneRepMaxes[1].exercises[0].reps, 2)
        XCTAssertEqual(oneRepMaxes[1].exercises[0].weight, 225)
        XCTAssertEqual(oneRepMaxes[1].exercises[0].oneRepMax, 231.42857142857142)

        XCTAssertEqual(oneRepMaxes[2].name, "Deadlift")
        XCTAssertEqual(oneRepMaxes[2].exercises.count, 1)
        XCTAssertEqual(oneRepMaxes[2].exercises[0].reps, 3)
        XCTAssertEqual(oneRepMaxes[2].exercises[0].weight, 315)
        XCTAssertEqual(oneRepMaxes[2].exercises[0].oneRepMax, 333.5294117647059)

        XCTAssertEqual(oneRepMaxes[3].name, "Biceps Curl")
        XCTAssertEqual(oneRepMaxes[3].exercises.count, 3)
        
        XCTAssertEqual(oneRepMaxes[3].exercises[0].reps, 6)
        XCTAssertEqual(oneRepMaxes[3].exercises[0].weight, 50)
        XCTAssertEqual(oneRepMaxes[3].exercises[0].oneRepMax, 58.06451612903226)
        
        XCTAssertEqual(oneRepMaxes[3].exercises[1].reps, 8)
        XCTAssertEqual(oneRepMaxes[3].exercises[1].weight, 30)
        XCTAssertEqual(oneRepMaxes[3].exercises[1].oneRepMax, 37.241379310344826)
        
        XCTAssertEqual(oneRepMaxes[3].exercises[2].reps, 10)
        XCTAssertEqual(oneRepMaxes[3].exercises[2].weight, 50)
        XCTAssertEqual(oneRepMaxes[3].exercises[2].oneRepMax, 66.66666666666666)
    }
}

// MARK: - Mocks

struct MockError: Error { }

struct MockDataStore: DataStoreInterface {
    var mockResult: (Result<[Exercise], Error>)?
    var exercises: [Exercise] {
        get async throws {
            guard let mockResult
            else {
                return []
            }
            
            switch mockResult {
            case .success(let exercises):
                return exercises
            case .failure(let error):
                throw error
            }
        }
    }
}
