import Foundation

extension Bundle {
    var sample1: URL? {
        url(forResource: "sample1", withExtension: "txt")
    }
}
