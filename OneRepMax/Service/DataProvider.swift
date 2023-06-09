import Foundation
import OrderedCollections

protocol DataProviderInterface {
    /// An array of one rep maxes
    var oneRepMaxes: [OneRepMax] { get async throws }
}

/// The data provider is responsible for sorting and ordering data
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
            //      key: "Back Squat",
            //      value: [
            //          key: "date1", value: [Exercise],
            //          key: "date2", value: [Exercise],
            //          ...
            //      ],
            //      key: "Deadlift",
            //      value: [
            //          key: "date3", value: [Exercise],
            //          key: "date4", value: [Exercise],
            //      ],
            //      ...
            // ]
            let exercisesOrderedByNameAndDate = exercisesOrderedByName.mapValues { OrderedDictionary(grouping: $0, by: \.date) }
            
            return exercisesOrderedByNameAndDate.elements.compactMap { (name, exercisesOrderedByDate) in
                // Get only the exercise with maximum one rep max for each of the day groups
                let oneRepMaxExercises = exercisesOrderedByDate.compactMapValues { exercises in
                    exercises.max { e1, e2 in e1.oneRepMax < e2.oneRepMax }
                }
                
                // Sort all the maximum one rep maxes by date in an ascending order
                let oneRepMaxExercisesSortedAscending = oneRepMaxExercises.values.elements.sorted { e1, e2 in e1.date < e2.date }
                
                // Get the personal best one rep max
                guard let personalBestExercise = oneRepMaxExercisesSortedAscending.max(by: { e1, e2 in
                    e1.oneRepMax < e2.oneRepMax
                })
                else { return nil }
                
                // Get the latest one rep max
                guard let lastExercise = oneRepMaxExercisesSortedAscending.last
                else { return nil }
                
                // Map data
                return OneRepMax(
                    exercises: oneRepMaxExercisesSortedAscending,
                    name: name,
                    personalBestExercise: personalBestExercise,
                    lastExercise: lastExercise
                )
            }
            // Sort by name lexicographically
            .sorted { $0.name < $1.name }
        }
    }
}
