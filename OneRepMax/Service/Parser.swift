import Foundation

protocol ParserInterface {
    func parseExercises(from input: String) async throws -> [Exercise]
}

struct Parser {
    private let dateFormatter: DateFormatter
    
    init(dateFormatter: DateFormatter = DateFormatter()) {
        self.dateFormatter = dateFormatter
    }
    
    private func parseExercise(from input: String) -> Exercise? {
        // Example:
        // Oct 11 2020,Back Squat,1,10,45
        //
        // Field order:
        // Date | Name | Sets | Reps | Weight
        let fields = input.split(separator: ",")
        
        guard
            fields.count == 5,
            let date = dateFormatter.date(from: String(fields[0])),
            let sets = Int(fields[2]),
            let reps = Int(fields[3]),
            let weight = Int(fields[4])
        else { return nil }
        
        return Exercise(date: date, name: String(fields[1]), reps: reps, sets: sets, weight: weight)
    }
}

extension Parser: ParserInterface {
    func parseExercises(from input: String) -> [Exercise] {
        input
            .split(separator: "\n")
            .compactMap { parseExercise(from: String($0)) }
    }
}
