import SwiftUI

final class AppCoordinator: ObservableObject {
    private let tabCoordinator = TabCoordinator()
    
    init() {
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        
        // Configure title attributes
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label
        ]
        
        // Apply the appearance to all navigation bars
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    @ViewBuilder
    func start() -> some View {
        tabCoordinator.tabView()
    }
} 
 
