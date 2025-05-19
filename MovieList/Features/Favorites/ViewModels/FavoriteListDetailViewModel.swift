import Foundation
import Combine

@MainActor
final class FavoriteListDetailViewModel: ObservableObject {
    @Published private(set) var movies: [FavoriteMovie] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published var lists: [FavoriteList] = []
    
    let list: FavoriteList
    private let repository: FavoriteRepositoryProtocol
    
    init(list: FavoriteList, repository: FavoriteRepositoryProtocol = FavoriteRepository()) {
        self.list = list
        self.repository = repository
    }
    
    func loadMovies() {
        isLoading = true
        error = nil
        
        if let movies = list.movies?.allObjects as? [FavoriteMovie] {
            self.movies = movies.sorted { $0.order < $1.order }
        }
        
        isLoading = false
    }
    
    func loadLists() {
        do {
            lists = try repository.fetchAllLists().filter { $0 != list }
        } catch {
            self.error = error
        }
    }
	
	func addMovie(imdbID: String, title: String, posterPath: String?) {
		do {
			let movie = try repository.addMovie(imdbID: imdbID, title: title, year: nil, posterPath: posterPath, to: list)
			movies.append(movie)
		} catch {
			self.error = error
		}
	}
    
    func removeMovie(_ movie: FavoriteMovie) {
        do {
            try repository.removeMovie(movie)
            if let index = movies.firstIndex(where: { $0.id == movie.id }) {
                movies.remove(at: index)
            }
        } catch {
            self.error = error
        }
    }
    
    func moveMovie(_ movie: FavoriteMovie, to targetList: FavoriteList) {
        do {
            try repository.moveMovie(movie, to: targetList)
            if let index = movies.firstIndex(where: { $0.id == movie.id }) {
                movies.remove(at: index)
            }
        } catch {
            self.error = error
        }
    }
    
    func reorderMovies() {
        do {
            try repository.reorderMovies(in: list)
            loadMovies() // Reload to get the new order
        } catch {
            self.error = error
        }
    }
} 
