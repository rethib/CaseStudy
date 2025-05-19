import SwiftUI

struct FavoritesView: View {
    var body: some View {
        EmptyStateView(
            title: LocalizationKey.Favorites.Movies.noFavorites.localized,
            message: LocalizationKey.Favorites.Movies.noFavoritesMessage.localized
        )
    }
} 