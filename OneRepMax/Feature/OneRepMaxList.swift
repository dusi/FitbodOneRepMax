import SwiftUI

/// The model that is responsible for loading an array of one rep maxes and presenting it to the user.
@MainActor
class OneRepMaxListModel: ObservableObject {
    /// The 4 view states that user can see
    enum State {
        case empty
        case error(String)
        case list([OneRepMax])
        case loading
    }

    /// The state that is presented to the user
    @Published var state: State
    
    /// The data provider used to load an array of one max rep exercises
    private let dataProvider: DataProviderInterface
    
    init(
        dataProvider: DataProviderInterface,
        state: State = .loading
    ) {
        self.dataProvider = dataProvider
        self.state = state
    }
}

extension OneRepMaxListModel {
    /// An input to notify the model to load one rep maxes prior to view appearing
    func task() {
        Task {
            do {
                let oneRepMaxes = try await self.dataProvider.oneRepMaxes
                self.state = oneRepMaxes.count > 0 ? .list(oneRepMaxes) : .empty
            } catch {
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
#if DEBUG   // For debugging purposes only
    /// An input that allows changing the data source strictly for debugging purposes
    func task(with option: Environment.DataSourceOption) {
        Environment.dataSourceOption = option
        
        task()
    }
#endif
}

/// The view that displays list of one rep maxes
struct OneRepMaxList: View {
    /// The model that provides most of the business logic
    @ObservedObject private var model: OneRepMaxListModel
    
#if DEBUG   // For debugging purposes only
    /// Selected menu item
    @State private var menuSelection: Int = 0
#endif
    
    init(model: OneRepMaxListModel) {
        self.model = model
    }
    
    var body: some View {
        NavigationSplitView {
            Group {
                switch self.model.state {
                case .empty:
                    Text("Empty")
                case .error(let localizedDescription):
                    Text("Error: \(localizedDescription)")
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
            #if DEBUG   // For debugging purposes only
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Simple menu that allows overriding the data source
                    Menu {
                        Text("Override data source")
                            Picker("", selection: self.$menuSelection) {
                                HStack {
                                    Text("Default")
                                    Image(systemName: "chart.xyaxis.line")
                                }
                                .tag(Environment.DataSourceOption.default.rawValue)
                                HStack {
                                    Text("Empty")
                                    Image(systemName: "0.square")
                                }
                                .tag(Environment.DataSourceOption.empty.rawValue)
                                HStack {
                                    Text("Invalid")
                                    Image(systemName: "exclamationmark.triangle")
                                }
                                .tag(Environment.DataSourceOption.invalid.rawValue)
                            }
                            .onChange(of: self.menuSelection) { newValue in
                                guard let option = Environment.DataSourceOption(rawValue: newValue)
                                else { return }
                                self.model.task(with: option)
                            }
                    } label: {
                        if self.menuSelection == Environment.DataSourceOption.default.rawValue {
                            Image(systemName: "ladybug")
                        } else {
                            Image(systemName: "ladybug.fill")
                        }
                    }
                }
            }
            #endif
        } detail: {
            Image(systemName: "chart.xyaxis.line")
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
                            dateFormatter: DateFormatter.input
                        )
                    )
                ),
                state: .loading
            )
        )
    }
}
