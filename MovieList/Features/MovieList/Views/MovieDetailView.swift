import SwiftUI
import Foundation
// If these are in a module, import the module. Otherwise, this ensures the compiler sees the types.
// import Favorites
// import MovieListViewModels

struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel
    private let movie: MovieDetail
    
    init(movie: MovieDetail) {
        self.movie = movie
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movie: movie))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Poster and Basic Info
                posterSection
                
                // Main Info
                Group {
                    titleSection
                    ratingSection
                    plotSection
                    castSection
                    technicalDetailsSection
                    additionalInfoSection
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(LocalizationKey.MovieDetails.title.localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
    
    private var posterSection: some View {
        AsyncImage(url: URL(string: movie.poster)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .aspectRatio(2/3, contentMode: .fit)
                .overlay {
                    Image(systemName: "film")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(movie.title)
                .font(.title)
                .fontWeight(.bold)
            
            HStack {
                Text(movie.year)
                Text("•")
                Text(movie.runtime)
                Text("•")
                Text(movie.rated)
            }
            .foregroundColor(.secondary)
        }
    }
    
    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizationKey.MovieDetails.ratings.localized)
                .font(.headline)
            
            HStack(spacing: 20) {
                if let imdbRating = Double(movie.imdbRating) {
                    RatingView(title: LocalizationKey.MovieDetails.imdbRating.localized, rating: imdbRating, total: 10)
                }
                
                if let metascore = Double(movie.metascore) {
                    RatingView(title: LocalizationKey.MovieDetails.metascoreRating.localized, rating: metascore, total: 100)
                }
            }
            
            ForEach(movie.ratings, id: \.source) { rating in
                Text("\(rating.source): \(rating.value)")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var plotSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizationKey.MovieDetails.plot.localized)
                .font(.headline)
            
            Text(movie.plot)
                .foregroundColor(.secondary)
        }
    }
    
    private var castSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Group {
                LabeledContent(LocalizationKey.MovieDetails.director.localized, value: movie.director)
                LabeledContent(LocalizationKey.MovieDetails.writer.localized, value: movie.writer)
                LabeledContent(LocalizationKey.MovieDetails.actors.localized, value: movie.actors)
            }
        }
    }
    
    private var technicalDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizationKey.MovieDetails.title.localized)
                .font(.headline)
            
            Group {
                LabeledContent(LocalizationKey.MovieDetails.genre.localized, value: movie.genre)
                LabeledContent(LocalizationKey.MovieDetails.language.localized, value: movie.language)
                LabeledContent(LocalizationKey.MovieDetails.country.localized, value: movie.country)
                if !movie.awards.isEmpty {
                    LabeledContent(LocalizationKey.MovieDetails.awards.localized, value: movie.awards)
                }
            }
        }
    }
    
    private var additionalInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let boxOffice = movie.boxOffice, !boxOffice.isEmpty {
                LabeledContent(LocalizationKey.MovieDetails.boxOffice.localized, value: boxOffice)
            }
            if let production = movie.production, !production.isEmpty {
                LabeledContent(LocalizationKey.MovieDetails.production.localized, value: production)
            }
            if let dvd = movie.dvd, !dvd.isEmpty {
                LabeledContent(LocalizationKey.MovieDetails.dvdRelease.localized, value: dvd)
            }
        }
    }
}

struct RatingView: View {
    let title: String
    let rating: Double
    let total: Double
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(String(format: "%.1f", rating))
                .font(.title2)
                .fontWeight(.bold)
            
            Text("/ \(Int(total))")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct LabeledContent: View {
    let title: String
    let value: String
    
    init(_ title: String, value: String) {
        self.title = title
        self.value = value
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MovieDetailView(movie: .mock)
        }
    }
} 