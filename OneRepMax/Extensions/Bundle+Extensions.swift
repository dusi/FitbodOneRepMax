import Foundation

extension Bundle {
    /// A url for the sample.txt file
    var sample: URL? {
        url(forResource: "sample", withExtension: "txt")
    }
    
    /// A url for the sample-large.txt
    var sampleLarge: URL? {
        url(forResource: "sample-large", withExtension: "txt")
    }
    
    /// A url for the empty.txt file
    var empty: URL? {
        url(forResource: "empty", withExtension: "txt")
    }
    
    /// A url for a non-existent file used for simulating error data input
    var invalid: URL? {
        url(forResource: "invalid-resource", withExtension: nil)
    }
}
