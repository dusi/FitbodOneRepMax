import Foundation

protocol ParserInterface {
    func parseExercises(from input: String) async throws -> [Exercise]
}

struct Parser: ParserInterface {
    func parseExercises(from input: String) async throws -> [Exercise] {
        [
            Exercise(name: "Bench Press"),
            Exercise(name: "Deadlift")
        ]
    }
}
