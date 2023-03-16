import Foundation

protocol DataStoreInterface {
    /// An array of all exercises
    var exercises: [Exercise] { get async throws }
}

/// The live implementation of data source
class DataStore {
    enum DataError: Error {
        case invalidUrl
        case inputSerialization
    }
    
    /// The parser that can map input String to output Exercise
    private let parser: ParserInterface
    
    init(
        parser: ParserInterface
    ) {
        self.parser = parser
    }
}

extension DataStore: DataStoreInterface {
    private var exercisesUrl: URL? {
#if DEBUG   // For debugging purposes only
        switch Environment.dataSourceOption {
        case .default:
            return Bundle.main.sample
        case .empty:
            return Bundle.main.empty
        case .invalid:
            return Bundle.main.invalid
        }
#else
        return Bundle.main.sample
#endif
    }
    
    // If changed to a function that takes path url we can mock it (real, empty, invalid-url)
    var exercises: [Exercise] {
        get async throws {
            // Make url optional will help us test cached exercises
            guard let exercisesUrl
            else {
                throw DataError.invalidUrl
            }
            
            // Read data from our sample url
            let data = try Data(contentsOf: exercisesUrl)
            
            // Serialize data
            guard let input = String(data: data, encoding: .utf8)
            else {
                throw DataError.inputSerialization
            }
            
            // Parse data
            return try await parser.parseExercises(from: input)
        }
    }
}
