import Foundation

#if DEBUG   // For debugging purposes only
/// Environment is solely used for debugging purposes as an in-memory cache for selected data source override
/// This should allow for easier testing.
struct Environment {
    enum DataSourceOption: Int {
        case `default`
        case empty
        case invalid
    }
    
    static var dataSourceOption = DataSourceOption.default
}
#endif
