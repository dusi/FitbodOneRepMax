import Foundation

protocol DataStoreInterface {
    var exercises: [Exercise] { get async }
}

struct DataStore: DataStoreInterface {
    var exercises: [Exercise] {
        get async {
            [
                Exercise(name: "Bench Press"),
                Exercise(name: "Deadlift")
            ]
        }
    }
}
