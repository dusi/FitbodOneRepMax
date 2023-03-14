import SwiftUI

protocol OneRepMaxListDataInterface {
    func task()
}

@MainActor
class OneRepMaxListModel: ObservableObject {
    enum State {
        case error
        case list([OneRepMax])
        case loading
    }

    @Published var state: State
    
    private let dataProvider: DataProviderInterface
    
    init(
        dataProvider: DataProviderInterface,
        state: State = .loading
    ) {
        self.dataProvider = dataProvider
        self.state = state
    }
}

extension OneRepMaxListModel: OneRepMaxListDataInterface {
    func task() {
        Task {
            do {
                let oneRepMaxes = try await dataProvider.oneRepMaxes
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
                dataProvider: DataProvider(
                    dataStore: DataStore(
                        parser: Parser(
                            dateFormatter: DateFormatter.default()
                        )
                    )
                ),
                state: .loading
            )
        )
    }
}
