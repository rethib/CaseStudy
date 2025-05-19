import Foundation

struct SearchResponse: Codable {
    let search: [MovieSummary]
    let totalResults: String
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults = "totalResults"
        case response = "Response"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        search = try container.decode([MovieSummary].self, forKey: .search)
        totalResults = try container.decode(String.self, forKey: .totalResults)
        response = try container.decode(String.self, forKey: .response)
    }
} 