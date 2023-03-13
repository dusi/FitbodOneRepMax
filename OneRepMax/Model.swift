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
