import SwiftUI

@main
struct OneRepMaxApp: App {
    var body: some Scene {
        WindowGroup {
            OneRepMaxList(
                model: OneRepMaxListModel(
                    dataProvider: DataProvider(
                        dataStore: DataStore(
                            parser: Parser(
                                dateFormatter: DateFormatter.input
                            )
                        )
                    )
                )
            )
        }
    }
}
