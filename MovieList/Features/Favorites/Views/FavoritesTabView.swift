import SwiftUI

struct FavoritesTabView: View {
    @StateObject private var viewModel = FavoriteListsViewModel()
    
    var body: some View {
        NavigationStack {
            FavoriteListsView(viewModel: viewModel)
                .navigationTitle(LocalizationKey.Favorites.title.localized)
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    Task {
                        await viewModel.loadLists()
                    }
                }
        }
    }
} 