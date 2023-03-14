import SwiftUI

@main
struct OneRepMaxApp: App {
    var body: some Scene {
        WindowGroup {
            OneRepMaxList(
                model: OneRepMaxListModel(
                    dataStore: DataStore(
                        parser: Parser(
                            dateFormatter: DateFormatter.default()
                        )
                    )
                )
            )
        }
    }
}
