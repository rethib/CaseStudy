import Foundation

enum Endpoint {
    case search(query: String, page: Int = 1)
    case movieDetail(id: String)
    
    private var baseURL: String { "https://www.omdbapi.com/" }
    private var apiKey: String { "269be912" }
    
    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [URLQueryItem(name: "apikey", value: apiKey)]
        
        switch self {
        case .search(let query, let page):
            components?.queryItems?.append(contentsOf: [
                URLQueryItem(name: "s", value: query),
                URLQueryItem(name: "page", value: String(page))
            ])
        case .movieDetail(let id):
            components?.queryItems?.append(contentsOf: [
                URLQueryItem(name: "i", value: id),
                URLQueryItem(name: "plot", value: "full")
            ])
        }
        
        return components?.url
    }
} 