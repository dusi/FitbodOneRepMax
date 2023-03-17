import Foundation

/// A unit of exercise
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

/// A unit of grouped exercises based on their name including an array of one rep maxes
struct OneRepMax: Identifiable {
    let id: UUID = UUID()
    let exercises: [Exercise]
    let name: String
    let personalBestExercise: Exercise
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
    
    static let best = Self(
        date: Date(),
        name: "Deadlift",
        reps: 10,
        sets: 1,
        weight: 400
    )
    
    static func mock(name: String, date: Date, sets: Int, weight: Int) -> Self {
        Self(
            date: date,
            name: name,
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
        personalBestExercise: .best,
        lastExercise: .mock
    )
    
    static func mock(name: String, exercises: [Exercise]) -> Self {
        guard let last = exercises.last
        else {
            return Self(
                exercises: [],
                name: name,
                personalBestExercise: .best,
                lastExercise: .mock
            )
        }
        
        return Self(
            exercises: exercises,
            name: name,
            personalBestExercise: .best,
            lastExercise: last
        )
    }
}
