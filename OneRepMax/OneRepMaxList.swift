import SwiftUI

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

extension OneRepMaxListModel {
    func task() {
        Task {
            do {
                let oneRepMaxes = try await self.dataProvider.oneRepMaxes
                self.state = .list(oneRepMaxes)
            } catch {
                self.state = .error
            }
        }
    }
    
#if DEBUG
    func task(with option: Environment.DataSourceOption) {
        Environment.dataSourceOption = option
        
        task()
    }
#endif
}

struct OneRepMaxList: View {
    @ObservedObject private var model: OneRepMaxListModel
    
#if DEBUG
    @State private var menuSelection: Int = 0
#endif
    
    init(model: OneRepMaxListModel) {
        self.model = model
    }
    
    var body: some View {
        NavigationSplitView {
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
            // ⚠️ Debug Mode - Enable runtime change of the data source for better testability.
            #if DEBUG
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Text("Override data source")
                            Picker("Test", selection: self.$menuSelection) {
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
                            dateFormatter: DateFormatter.input()
                        )
                    )
                ),
                state: .loading
            )
        )
    }
}
