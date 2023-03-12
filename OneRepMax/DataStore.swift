import Foundation

protocol DataStoreInterface {
    var exercises: [Exercise] { get async throws }
}

struct DataStore {
    enum DataError: Error {
        case invalidUrl
        case inputSerialization
    }
    
    private let bundle: Bundle
    private let parser: ParserInterface
    
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
            return try await parser.parseExercises(from: input)
        }
    }
}
