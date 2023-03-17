import Foundation

protocol DataStoreInterface {
    /// An array of all exercises
    var exercises: [Exercise] { get async throws }
}

/// The data store is responsible for reading data from the disk
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
        case .large:
            return Bundle.main.sampleLarge
        case .empty:
            return Bundle.main.empty
        case .invalid:
            return Bundle.main.invalid
        }
#else
        return Bundle.main.sample
#endif
    }
    
    var exercises: [Exercise] {
        get async throws {
            // Make url optional will help us test cached exercises
            guard let exercisesUrl
            else {
                throw DataError.invalidUrl
            }
            
            // Read data from our sample url
            // Please note that we're reading the whole file into memory at once
            // A more robust solution might be to read sequentially line by line
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
