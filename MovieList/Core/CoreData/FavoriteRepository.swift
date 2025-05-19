import CoreData
import Foundation

protocol FavoriteRepositoryProtocol {
    func createList(name: String) throws -> FavoriteList
    func deleteList(_ list: FavoriteList) throws
    func updateList(_ list: FavoriteList, newName: String) throws
    func fetchAllLists() throws -> [FavoriteList]
    func addMovie(imdbID: String, title: String, year: String?, posterPath: String?, to list: FavoriteList) throws -> FavoriteMovie
    func removeMovie(_ movie: FavoriteMovie) throws
    func moveMovie(_ movie: FavoriteMovie, to list: FavoriteList) throws
    func reorderMovies(in list: FavoriteList) throws
}

final class FavoriteRepository: FavoriteRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.viewContext) {
        self.context = context
    }
    
    func createList(name: String) throws -> FavoriteList {
        let list = FavoriteList(context: context)
        list.id = UUID()
        list.name = name
        list.createdAt = Date()
        list.updatedAt = Date()
        try context.save()
        return list
    }
    
    func deleteList(_ list: FavoriteList) throws {
        context.delete(list)
        try context.save()
    }
    
    func updateList(_ list: FavoriteList, newName: String) throws {
        list.name = newName
        list.updatedAt = Date()
        try context.save()
    }
    
    func fetchAllLists() throws -> [FavoriteList] {
        let request: NSFetchRequest<FavoriteList> = FavoriteList.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavoriteList.updatedAt, ascending: false)]
        return try context.fetch(request)
    }
    
    func addMovie(imdbID: String, title: String, year: String?, posterPath: String?, to list: FavoriteList) throws -> FavoriteMovie {
        // Check if movie already exists in the list
        if let existingMovies = list.movies?.allObjects as? [FavoriteMovie],
           existingMovies.contains(where: { $0.imdbID == imdbID }) {
            throw NSError(domain: "FavoriteRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Movie already exists in this list"])
        }

        let movie = FavoriteMovie(context: context)
        movie.imdbID = imdbID
        movie.title = title
        movie.year = year
        movie.posterPath = posterPath
        movie.addedAt = Date()
        movie.list = list
        movie.order = Int16(list.movies?.count ?? 0)
        
        list.updatedAt = Date()
        try context.save()
        return movie
    }
    
    func removeMovie(_ movie: FavoriteMovie) throws {
        context.delete(movie)
        try context.save()
    }
    
    func moveMovie(_ movie: FavoriteMovie, to list: FavoriteList) throws {
        movie.list = list
        movie.order = Int16(list.movies?.count ?? 0)
        list.updatedAt = Date()
        try context.save()
    }
    
    func reorderMovies(in list: FavoriteList) throws {
        guard let movies = list.movies?.allObjects as? [FavoriteMovie] else { return }
        let sortedMovies = movies.sorted { $0.order < $1.order }
        
        for (index, movie) in sortedMovies.enumerated() {
            movie.order = Int16(index)
        }
        
        try context.save()
    }
} 