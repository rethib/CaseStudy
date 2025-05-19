import SwiftUI

struct FavoriteListDetailView: View {
    @StateObject private var viewModel: FavoriteListDetailViewModel
    @State private var movieToDelete: FavoriteMovie?
    @State private var movieToMove: FavoriteMovie?
    @State private var showingMoveSheet = false
    
    init(list: FavoriteList) {
        _viewModel = StateObject(wrappedValue: FavoriteListDetailViewModel(list: list))
    }
    
    var body: some View {
        mainContent
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.list.name ?? "")
                        .font(.headline)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadMovies()
                viewModel.loadLists()
            }
            .alert(LocalizationKey.Common.remove.localized, isPresented: .init(
                get: { movieToDelete != nil },
                set: { if !$0 { movieToDelete = nil } }
            )) {
                Button(LocalizationKey.Common.cancel.localized, role: .cancel) {
                    movieToDelete = nil
                }
                Button(LocalizationKey.Common.remove.localized, role: .destructive) {
                    if let movie = movieToDelete {
                        viewModel.removeMovie(movie)
                    }
                    movieToDelete = nil
                }
            } message: {
                Text(LocalizationKey.Favorites.Movies.removeMessage.localized)
            }
            .sheet(isPresented: $showingMoveSheet) {
                moveSheetContent
            }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if viewModel.movies.isEmpty {
            emptyStateView
        } else {
            movieListView
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "film")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text(LocalizationKey.Favorites.Movies.empty.localized)
                .font(.title3)
                .bold()
            Text(LocalizationKey.Favorites.Movies.emptyMessage.localized)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var movieListView: some View {
        List {
            ForEach(viewModel.movies) { movie in
                FavoriteMovieRow(movie: movie)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            movieToDelete = movie
                        } label: {
                            Label(LocalizationKey.Common.remove.localized, systemImage: "trash")
                        }
                        
                        Button {
                            movieToMove = movie
                            showingMoveSheet = true
                        } label: {
                            Label(LocalizationKey.Common.move.localized, systemImage: "arrow.right")
                        }
                        .tint(.blue)
                    }
            }
            .onMove { from, to in
                // TODO: Implement reordering
            }
        }
    }
    
    private var moveSheetContent: some View {
        NavigationStack {
            List {
                ForEach(viewModel.lists) { list in
                    Button {
                        if let movie = movieToMove {
                            viewModel.moveMovie(movie, to: list)
                        }
                        showingMoveSheet = false
                        movieToMove = nil
                    } label: {
                        Text(list.name ?? "")
                    }
                }
            }
            .navigationTitle(LocalizationKey.Favorites.Lists.moveTitle.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizationKey.Common.cancel.localized) {
                        showingMoveSheet = false
                        movieToMove = nil
                    }
                }
            }
        }
    }
}

struct FavoriteMovieRow: View {
    let movie: FavoriteMovie
    
    var body: some View {
        HStack {
            if let posterPath = movie.posterPath {
                AsyncImage(url: URL(string: posterPath)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 60, height: 90)
                .cornerRadius(8)
            } else {
                Image(systemName: "film")
                    .frame(width: 60, height: 90)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading) {
                Text(movie.title ?? "")
                    .font(.headline)
                if let year = movie.year {
                    Text(year)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
} 