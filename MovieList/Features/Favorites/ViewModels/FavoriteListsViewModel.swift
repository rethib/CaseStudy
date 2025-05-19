import Foundation
import Combine

@MainActor
final class FavoriteListsViewModel: ObservableObject {
    @Published private(set) var lists: [FavoriteList] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let repository: FavoriteRepositoryProtocol
    
    init(repository: FavoriteRepositoryProtocol = FavoriteRepository()) {
        self.repository = repository
    }
    
    func loadLists() async {
        isLoading = true
        error = nil
        
        do {
            lists = try repository.fetchAllLists()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func createList(name: String) async {
        do {
            let newList = try repository.createList(name: name)
            lists.insert(newList, at: 0)
        } catch {
            self.error = error
        }
    }
    
    func deleteList(_ list: FavoriteList) async {
        do {
            try repository.deleteList(list)
            if let index = lists.firstIndex(where: { $0.id == list.id }) {
                lists.remove(at: index)
            }
        } catch {
            self.error = error
        }
    }
    
    func updateList(_ list: FavoriteList, newName: String) async {
        do {
            try repository.updateList(list, newName: newName)
            if let index = lists.firstIndex(where: { $0.id == list.id }) {
                lists[index] = list
            }
        } catch {
            self.error = error
        }
    }
} 