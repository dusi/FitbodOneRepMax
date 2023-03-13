import Foundation

struct Exercise {
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
    let id = UUID()
    let exercises: [Exercise]
    let name: String
    let latestOneRepMax: Double
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
}

extension OneRepMax {
    static let mock = OneRepMax(
        exercises: [.mock],
        name: "Deadlift",
        latestOneRepMax: Exercise.mock.oneRepMax
    )
}
