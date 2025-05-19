import Foundation

struct MovieSummary: Codable, Identifiable, Equatable {
    let title: String
    let imdbID: String
    let year: String?
    let type: String?
    let poster: String?
    var isFavorite: Bool = false
    
    var id: String { imdbID }
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
} 