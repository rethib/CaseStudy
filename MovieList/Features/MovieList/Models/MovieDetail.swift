import Foundation

struct MovieDetail: Codable, Identifiable {
    let title: String
    let year: String
    let rated: String
    let released: String
    let runtime: String
    let genre: String
    let director: String
    let writer: String
    let actors: String
    let plot: String
    let language: String
    let country: String
    let awards: String
    let poster: String
    let ratings: [Rating]
    let metascore: String
    let imdbRating: String
    let imdbVotes: String
    let imdbID: String
    let type: String
    let dvd: String?
    let boxOffice: String?
    let production: String?
    let website: String?
    let response: String
    
    var id: String { imdbID }
    
    struct Rating: Codable {
        let source: String
        let value: String
        
        enum CodingKeys: String, CodingKey {
            case source = "Source"
            case value = "Value"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating = "imdbRating"
        case imdbVotes = "imdbVotes"
        case imdbID = "imdbID"
        case type = "Type"
        case dvd = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case response = "Response"
    }
}

// MARK: - Mock Data
extension MovieDetail {
    static var mock: MovieDetail {
        MovieDetail(
            title: "The Shawshank Redemption",
            year: "1994",
            rated: "R",
            released: "14 Oct 1994",
            runtime: "142 min",
            genre: "Drama",
            director: "Frank Darabont",
            writer: "Stephen King, Frank Darabont",
            actors: "Tim Robbins, Morgan Freeman, Bob Gunton",
            plot: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
            language: "English",
            country: "United States",
            awards: "Nominated for 7 Oscars",
            poster: "https://m.media-amazon.com/images/M/MV5BMDFkYTc0MGEtZmNhMC00ZDIzLWFmNTEtODM1ZmRlYWMwMWFmXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg",
            ratings: [
                Rating(source: "Internet Movie Database", value: "9.3/10"),
                Rating(source: "Rotten Tomatoes", value: "91%"),
                Rating(source: "Metacritic", value: "80/100")
            ],
            metascore: "80",
            imdbRating: "9.3",
            imdbVotes: "2,600,000",
            imdbID: "tt0111161",
            type: "movie",
            dvd: "27 Jan 1998",
            boxOffice: "$28,699,976",
            production: "Columbia Pictures",
            website: "N/A",
            response: "True"
        )
    }
} 