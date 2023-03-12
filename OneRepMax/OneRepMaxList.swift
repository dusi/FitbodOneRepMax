import SwiftUI

protocol OneRepMaxListDataInterface {
    func task()
}

@MainActor
class OneRepMaxListData: ObservableObject {
    enum State {
        case error
        case list
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

extension OneRepMaxListData: OneRepMaxListDataInterface {
    func task() {
        Task {
            do {
                let _ = await dataStore.exercises
                self.state = .list
            } catch {
                self.state = .error
            }
        }
    }
}

struct OneRepMaxList: View {
    @ObservedObject private var model: OneRepMaxListData
    
    init(model: OneRepMaxListData) {
        self.model = model
    }
    
    var body: some View {
        Group {
            switch self.model.state {
            case .error:
                Text("Error")
            case .list:
                Text("List")
            case .loading:
                Text("Loading..")
            }
        }
        .task {
            self.model.task()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OneRepMaxList(
            model: OneRepMaxListData(
                dataStore: DataStore(),
                state: .list
            )
        )
    }
}
