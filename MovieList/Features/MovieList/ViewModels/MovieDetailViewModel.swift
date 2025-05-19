// This is a source file for the MovieList target. Make sure it's included in the Xcode project and build target.

import Foundation
import CoreData

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published private(set) var isFavorite = false
    @Published var error: Error?
    
    private let movie: MovieDetail
    private let favoriteRepository: FavoriteRepositoryProtocol
    
    init(movie: MovieDetail, favoriteRepository: FavoriteRepositoryProtocol = FavoriteRepository()) {
        self.movie = movie
        self.favoriteRepository = favoriteRepository
    }
    
    func addToFavorites(list: FavoriteList) {
        Task {
            do {
                _ = try favoriteRepository.addMovie(
                    imdbID: movie.imdbID,
                    title: movie.title,
                    year: movie.year,
                    posterPath: movie.poster,
                    to: list
                )
                isFavorite = true
            } catch {
                self.error = error
            }
        }
    }
    
    func removeFromFavorites(_ favoriteMovie: FavoriteMovie) {
        Task {
            do {
                try favoriteRepository.removeMovie(favoriteMovie)
                isFavorite = false
            } catch {
                self.error = error
            }
        }
    }
} 