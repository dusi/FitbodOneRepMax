import Foundation
import OrderedCollections

protocol DataProviderInterface {
    var oneRepMaxes: [OneRepMax] { get async throws }
}

struct DataProvider {
    private let dataStore: DataStoreInterface
    
    init(dataStore: DataStoreInterface) {
        self.dataStore = dataStore
    }
}

extension DataProvider: DataProviderInterface {
    var oneRepMaxes: [OneRepMax] {
        get async throws {
            let exercises = try await dataStore.exercises
            
            // Example:
            // [
            //      key: "Back Squat", value: [Exercise],
            //      key: "Deadlift", value: [Exercise],
            //      ...
            // ]
            let exercisesOrderedByName = OrderedDictionary(grouping: exercises, by: \.name)
            
            // Example:
            // [
            //      key: "Back Squat", value: [
            //          key: "date1", value: [Exercise],
            //          key: "date2", value: [Exercise],
            //          ...
            //      ],
            //      key: "Deadlift", value: [
            //          key: "date3", value: [Exercise],
            //          key: "date4", value: [Exercise],
            //      ],
            //      ...
            // ]
            let exercisesOrderedByNameAndDate = exercisesOrderedByName.mapValues { OrderedDictionary(grouping: $0, by: \.date) }
            
            return exercisesOrderedByNameAndDate.elements.map { (name, exercisesOrderedByDate) in
                // Get the exercise with one-rep-max for each day
                let oneRepMaxExercises = exercisesOrderedByDate.compactMapValues { exercises in
                    exercises.max { e1, e2 in e1.oneRepMax < e2.oneRepMax }
                }
                
                // Sort exercises by date in an ascending order
                let oneRepMaxExercisesSortedAscending = oneRepMaxExercises.values.elements.sorted { e1, e2 in e1.date < e2.date }
                
                // Map data
                return OneRepMax(exercises: oneRepMaxExercisesSortedAscending, name: name)
            }
        }
    }
}
