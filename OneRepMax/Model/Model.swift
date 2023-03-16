import Foundation

struct Exercise: Identifiable, Equatable {
    let id: UUID = UUID()
    let date: Date
    let name: String
    let reps: Int
    let sets: Int
    let weight: Int
}

extension Exercise {
    var oneRepMax: Double {
        Double(weight) * (36 / (37.0 - Double(reps)))
    }
}

struct OneRepMax: Identifiable {
    let id: UUID = UUID()
    let exercises: [Exercise]
    let name: String
    let lastExercise: Exercise
}

// MARK: - Mocks

extension Exercise {
    static let mock = Self(
        date: Date(),
        name: "Deadlift",
        reps: 10,
        sets: 1,
        weight: 265
    )
    
    static func mock(name: String, date: Date, sets: Int, weight: Int) -> Self {
        Self(
            date: date,
            name: "Deadlift",
            reps: 10,
            sets: sets,
            weight: weight
        )
    }
}

extension OneRepMax {
    static let mock = Self(
        exercises: [.mock],
        name: "Deadlift",
        lastExercise: Exercise.mock
    )
    
    static func mock(name: String, exercises: [Exercise]) -> Self {
        guard let last = exercises.last
        else {
            return Self(
                exercises: [],
                name: name,
                lastExercise: .mock
            )
        }
        
        return Self(
            exercises: exercises,
            name: name,
            lastExercise: last
        )
    }
}