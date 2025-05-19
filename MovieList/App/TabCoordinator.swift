import SwiftUI

enum Tab {
    case movieList
    case favorites
    case settings
}

final class TabCoordinator: ObservableObject {
    @Published var selectedTab: Tab = .movieList
    
    @ViewBuilder
    func tabView() -> some View {
        TabView(selection: Binding(
            get: { self.selectedTab },
            set: { self.selectedTab = $0 }
        )) {
            NavigationStack {
                MovieListView(viewModel: MovieListViewModel(service: MovieService()))
            }
            .tabItem {
                Label(LocalizationKey.Movies.title.localized, systemImage: "film")
            }
            .tag(Tab.movieList)
            
            NavigationStack {
                FavoritesTabView()
            }
            .tabItem {
                Label(LocalizationKey.Favorites.title.localized, systemImage: "heart.fill")
            }
            .tag(Tab.favorites)
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label(LocalizationKey.Settings.title.localized, systemImage: "gearshape.fill")
            }
            .tag(Tab.settings)
        }
    }
} 