import Foundation

protocol DataStoreInterface {
    var exercises: [Exercise] { get async throws }
}

class DataStore {
    enum DataError: Error {
        case invalidUrl
        case inputSerialization
    }
    
    /// The bundle to use for loading data from
    private let bundle: Bundle
    
    /// The parser that can map input String to output Exercise
    private let parser: ParserInterface
    
    /// The in-memory cache
    private var cachedExercises: [Exercise]?
    
    init(
        bundle: Bundle = .main,
        parser: ParserInterface
    ) {
        self.bundle = bundle
        self.parser = parser
    }
}

extension DataStore: DataStoreInterface {
    var exercises: [Exercise] {
        get async throws {
            if let cachedExercises { return cachedExercises }
            
            guard let url = bundle.sample1
            else {
                throw DataError.invalidUrl
            }
            
            // Read data from our sample url
            let data = try Data(contentsOf: url)
            
            // Serialize data
            guard let input = String(data: data, encoding: .utf8)
            else {
                throw DataError.inputSerialization
            }
            
            // Parse data
            let exercises = try await parser.parseExercises(from: input)
            
            // Cache in-memory
            cachedExercises = exercises
            
            return exercises
        }
    }
}
