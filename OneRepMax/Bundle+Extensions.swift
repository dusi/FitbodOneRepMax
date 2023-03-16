import Foundation

extension Bundle {
    var sample: URL? {
        url(forResource: "sample", withExtension: "txt")
    }
    
    var empty: URL? {
        url(forResource: "empty", withExtension: "txt")
    }
    
    var invalid: URL? {
        url(forResource: "invalid-resource", withExtension: nil)
    }
}
