import OrderedCollections
import SwiftUI

@MainActor
class OneRepMaxListModel: ObservableObject {
    enum State {
        case error
        case list([OneRepMax])
        case loading
    }

    @Published var state: State
    
    private let dataStore: DataStoreInterface
    
    init(
        dataStore: DataStoreInterface,
        state: State = .loading
    ) {
        self.dataStore = dataStore
        self.state = state
    }
}

extension OneRepMaxListModel {
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
                
                // Sort all the maximum one rep max exercises by date in an ascending order
                let oneRepMaxExercisesSortedAscending = oneRepMaxExercises.values.elements.sorted { e1, e2 in e1.date < e2.date }
                
                // Get the latest one rep max
                guard let latestOneRepMax = oneRepMaxExercisesSortedAscending.last?.oneRepMax
                else { return nil }
                
                // Map data
                return OneRepMax(
                    exercises: oneRepMaxExercisesSortedAscending,
                    name: name,
                    latestOneRepMax: latestOneRepMax
                )
            }
            // Sort one max rep array by name lexicographically
            .sorted { $0.name < $1.name }
        }
    }
    
    func task() {
        Task {
            do {
                let oneRepMaxes = try await self.oneRepMaxes
                self.state = .list(oneRepMaxes)
            } catch {
                self.state = .error
            }
        }
    }
}

struct OneRepMaxList: View {
    @ObservedObject private var model: OneRepMaxListModel
    
    init(model: OneRepMaxListModel) {
        self.model = model
    }
    
    var body: some View {
        NavigationStack {
            Group {
                switch self.model.state {
                case .error:
                    Text("Error")
                case .list(let oneRepMaxes):
                    List {
                        ForEach(oneRepMaxes) { oneRepMax in
                            NavigationLink {
                                OneRepMaxDetail(oneRepMax: oneRepMax)
                            } label: {
                                OneRepMaxRow(oneRepMax: oneRepMax)
                            }
                        }
                    }
                    .listStyle(.plain)
                case .loading:
                    Text("Loading..")
                }
            }
            .navigationTitle("One Rep Max")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            self.model.task()
        }
    }
}

struct OneRepMaxList_Previews: PreviewProvider {
    static var previews: some View {
        OneRepMaxList(
            model: OneRepMaxListModel(
                dataStore: DataStore(
                    parser: Parser(
                        dateFormatter: DateFormatter.default()
                    )
                ),
                state: .loading
            )
        )
    }
}
