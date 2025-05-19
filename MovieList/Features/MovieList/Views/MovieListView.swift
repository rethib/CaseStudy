import SwiftUI

struct MovieListView: View {
    @ObservedObject private var viewModel: MovieListViewModel
    @EnvironmentObject private var coordinator: AppCoordinator
    @FocusState private var isSearchFocused: Bool
    
    // Update grid layout to be adaptive
    private let gridSpacing: CGFloat = 20
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 150, maximum: 170), spacing: gridSpacing)]
    }
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                searchBar
                Button {
                    isSearchFocused = false
                    Task {
                        await viewModel.searchMovies()
                    }
                } label: {
                    Text(LocalizationKey.Common.search.localized)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(UIColor.systemBackground))
            .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
            
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isLoading && viewModel.items.isEmpty {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.items.isEmpty && !viewModel.searchQuery.isEmpty {
                        EmptyStateView(
                            title: LocalizationKey.Movies.noResults.localized,
                            message: LocalizationKey.Movies.noResultsMessage.localized
                        )
                    } else {
                        LazyVGrid(columns: columns, spacing: gridSpacing) {
                            ForEach(viewModel.items) { movie in
                                NavigationLink {
                                    if let movieDetail = viewModel.movieDetails[movie.imdbID] {
                                        MovieDetailView(movie: movieDetail)
                                    } else {
                                        ProgressView()
                                            .task {
                                                await viewModel.fetchMovieDetail(id: movie.imdbID)
                                            }
                                    }
                                } label: {
                                    MovieGridCell(movie: movie) {
                                        viewModel.showFavoriteListSelection(for: movie)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.plain)
                            }
                            
                            if viewModel.isLoading && !viewModel.items.isEmpty {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        .padding(gridSpacing)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .onChange(of: viewModel.items.count) { _ in
                if !viewModel.items.isEmpty {
                    Task {
                        await viewModel.loadMoreMovies()
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showingFavoriteListSelection) {
            NavigationStack {
                FavoriteListSelectionView { list in
                    viewModel.addToFavorites(list: list)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField(LocalizationKey.Movies.searchPlaceholder.localized, text: $viewModel.searchQuery)
                .textFieldStyle(.plain)
                .focused($isSearchFocused)
                .onSubmit {
                    Task {
                        await viewModel.searchMovies()
                    }
                }
            
            if !viewModel.searchQuery.isEmpty {
                Button {
                    viewModel.searchQuery = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}