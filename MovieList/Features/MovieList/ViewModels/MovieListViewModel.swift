import Foundation
import CoreData

final class MovieListViewModel: ObservableObject {
    @Published private(set) var items: [MovieSummary] = []
    @Published private(set) var movieDetails: [String: MovieDetail] = [:]
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published var searchQuery = ""
    @Published var showingFavoriteListSelection = false
    @Published var selectedMovie: MovieSummary?
    
    private let service: MovieServiceProtocol
    private let favoriteRepository: FavoriteRepositoryProtocol
    private var currentPage = 1
    private var hasMorePages = true
    private var isLoadingMore = false
    
    init(service: MovieServiceProtocol, favoriteRepository: FavoriteRepositoryProtocol = FavoriteRepository()) {
        self.service = service
        self.favoriteRepository = favoriteRepository
    }
    
    @MainActor
    func clearItems() {
        items = []
        currentPage = 1
        hasMorePages = true
    }
    
    @MainActor
    func searchMovies() async {
        guard !searchQuery.isEmpty else { return }
        
        isLoading = true
        currentPage = 1
        hasMorePages = true
        
        do {
            let results = try await service.searchMovies(query: searchQuery, page: currentPage)
            items = results
            hasMorePages = !results.isEmpty
        } catch {
            self.error = error
            items = []
        }
        isLoading = false
    }
    
    @MainActor
    func loadMoreMovies() async {
        guard !searchQuery.isEmpty,
              hasMorePages,
              !isLoadingMore,
              !items.isEmpty else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        do {
            let newMovies = try await service.searchMovies(query: searchQuery, page: currentPage)
            if newMovies.isEmpty {
                hasMorePages = false
            } else {
                items.append(contentsOf: newMovies)
            }
        } catch {
            self.error = error
            currentPage -= 1
        }
        isLoadingMore = false
    }
    
    @MainActor
    func fetchMovieDetail(id: String) async {
        guard movieDetails[id] == nil else { return }
        
        do {
            let detail = try await service.fetchMovieDetail(id: id)
            movieDetails[id] = detail
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func showFavoriteListSelection(for movie: MovieSummary) {
        selectedMovie = movie
        showingFavoriteListSelection = true
    }
    
    @MainActor
    func addToFavorites(list: FavoriteList) {
        guard let movie = selectedMovie else { return }
        
        Task {
            do {
                _ = try favoriteRepository.addMovie(
                    imdbID: movie.imdbID,
                    title: movie.title,
                    year: movie.year,
                    posterPath: movie.poster,
                    to: list
                )
                
                // Update the movie's favorite status in the items array
                if let index = items.firstIndex(where: { $0.id == movie.id }) {
                    var updatedMovie = items[index]
                    updatedMovie.isFavorite = true
                    items[index] = updatedMovie
                }
                
                showingFavoriteListSelection = false
                selectedMovie = nil
            } catch {
                self.error = error
            }
        }
    }
} 