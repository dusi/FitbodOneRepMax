import SwiftUI

@main
struct OneRepMaxApp: App {
    var body: some Scene {
        WindowGroup {
            OneRepMaxList(
                model: OneRepMaxListData(
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
