import Foundation

extension DateFormatter {
    /// Data formatter used for parsing input data
    static var input: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        return dateFormatter
    }
    
    /// Data formatter used for display
    static var `default`: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter
    }
}
