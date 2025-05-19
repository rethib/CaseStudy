import Foundation

protocol MovieServiceProtocol {
    func searchMovies(query: String, page: Int) async throws -> [MovieSummary]
    func fetchMovieDetail(id: String) async throws -> MovieDetail
}

struct MovieService: MovieServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func searchMovies(query: String, page: Int = 1) async throws -> [MovieSummary] {
        let response: SearchResponse = try await networkService.request(.search(query: query, page: page))
        return response.search
    }
    
    func fetchMovieDetail(id: String) async throws -> MovieDetail {
        try await networkService.request(.movieDetail(id: id))
    }
}

struct MovieResponse: Codable {
    let results: [MovieSummary]
} 