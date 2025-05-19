import Foundation

enum LocalizationKey {
    // MARK: - Common
    enum Common {
        static let appName = "app.name"
        static let ok = "ok"
        static let cancel = "cancel"
        static let error = "error"
        static let success = "success"
        static let search = "search"
        static let delete = "delete"
        static let remove = "remove"
        static let rename = "rename"
        static let move = "move"
        static let add = "add"
        static let create = "create"
        static let new = "new"
    }
    
    // MARK: - Movies
    enum Movies {
        static let title = "movies.title"
        static let searchPlaceholder = "movies.search.placeholder"
        static let empty = "movies.empty"
        static let errorLoading = "movies.error.loading"
        static let noResults = "movies.no.results"
        static let noResultsMessage = "movies.no.results.message"
    }
    
    // MARK: - Movie Details
    enum MovieDetails {
        static let title = "movie.details.title"
        static let releaseDate = "movie.details.release.date"
        static let rating = "movie.details.rating"
        static let overview = "movie.details.overview"
        static let addToFavorites = "movie.details.add.to.favorites"
        static let removeFromFavorites = "movie.details.remove.from.favorites"
        static let ratings = "movie.details.ratings"
        static let plot = "movie.details.plot"
        static let director = "movie.details.director"
        static let writer = "movie.details.writer"
        static let actors = "movie.details.actors"
        static let genre = "movie.details.genre"
        static let language = "movie.details.language"
        static let country = "movie.details.country"
        static let awards = "movie.details.awards"
        static let boxOffice = "movie.details.box.office"
        static let production = "movie.details.production"
        static let dvdRelease = "movie.details.dvd.release"
        static let imdbRating = "movie.details.rating.imdb"
        static let metascoreRating = "movie.details.rating.metascore"
    }
    
    // MARK: - Favorites
    enum Favorites {
        static let title = "favorites.title"
        static let empty = "favorites.empty"
        
        enum Lists {
            static let title = "favorites.lists.title"
            static let empty = "favorites.lists.empty"
            static let emptyMessage = "favorites.lists.empty.message"
            static let add = "favorites.lists.add"
            static let new = "favorites.lists.new"
            static let name = "favorites.lists.name"
            static let deleteTitle = "favorites.lists.delete.title"
            static let deleteMessage = "favorites.lists.delete.message"
            static let moveTitle = "favorites.lists.move.title"
            static let noLists = "favorites.lists.no.lists"
            static let createListMessage = "favorites.lists.create.message"
            static let createList = "favorites.lists.create"
            static let addToList = "favorites.lists.add.to.list"
            static let rename = "favorites.lists.rename.title"
        }
        
        enum Movies {
            static let empty = "favorites.movies.empty"
            static let emptyMessage = "favorites.movies.empty.message"
            static let removeMessage = "favorites.movies.remove.message"
            static let noFavorites = "favorites.movies.no.favorites"
            static let noFavoritesMessage = "favorites.movies.no.favorites.message"
        }
    }
    
    // MARK: - Settings
    enum Settings {
        static let title = "settings.title"
        static let appInfo = "settings.app.info"
        static let version = "settings.version"
    }
} 