import SwiftUI

struct FavoriteListsView: View {
    @ObservedObject var viewModel: FavoriteListsViewModel
    @State private var showingAddList = false
    @State private var listToDelete: FavoriteList?
    @State private var listToRename: FavoriteList?
    @State private var newListName = ""
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.lists.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    Text(LocalizationKey.Favorites.Lists.empty.localized)
                        .font(.title3)
                        .bold()
                    Text(LocalizationKey.Favorites.Lists.emptyMessage.localized)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.lists) { list in
                        NavigationLink(value: list) {
                            FavoriteListRow(list: list)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                listToDelete = list
                            } label: {
                                Label(LocalizationKey.Common.delete.localized, systemImage: "trash")
                            }
                            
                            Button {
                                listToRename = list
                                newListName = list.name ?? ""
                            } label: {
                                Label(LocalizationKey.Common.rename.localized, systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                }
            }
        }
        .navigationDestination(for: FavoriteList.self) { list in
            FavoriteListDetailView(list: list)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddList = true
                } label: {
                    Label(LocalizationKey.Favorites.Lists.add.localized, systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddList) {
            NavigationStack {
                Form {
                    TextField(LocalizationKey.Favorites.Lists.name.localized, text: $newListName)
                }
                .navigationTitle(LocalizationKey.Favorites.Lists.new.localized)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(LocalizationKey.Common.cancel.localized) {
                            showingAddList = false
                            newListName = ""
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(LocalizationKey.Common.add.localized) {
                            Task {
                                await viewModel.createList(name: newListName)
                                showingAddList = false
                                newListName = ""
                            }
                        }
                        .disabled(newListName.isEmpty)
                    }
                }
            }
            .presentationDetents([.height(200)])
        }
        .alert(LocalizationKey.Favorites.Lists.deleteTitle.localized, isPresented: .init(
            get: { listToDelete != nil },
            set: { if !$0 { listToDelete = nil } }
        )) {
            Button(LocalizationKey.Common.cancel.localized, role: .cancel) {
                listToDelete = nil
            }
            Button(LocalizationKey.Common.delete.localized, role: .destructive) {
                if let list = listToDelete {
                    Task {
                        await viewModel.deleteList(list)
                    }
                }
                listToDelete = nil
            }
        } message: {
            Text(LocalizationKey.Favorites.Lists.deleteMessage.localized)
        }
        .alert(LocalizationKey.Favorites.Lists.rename.localized, isPresented: .init(
            get: { listToRename != nil },
            set: { if !$0 { listToRename = nil } }
        )) {
            TextField(LocalizationKey.Favorites.Lists.name.localized, text: $newListName)
            Button(LocalizationKey.Common.cancel.localized, role: .cancel) {
                listToRename = nil
                newListName = ""
            }
            Button(LocalizationKey.Common.rename.localized) {
                if let list = listToRename {
                    Task {
                        await viewModel.updateList(list, newName: newListName)
                    }
                }
                listToRename = nil
                newListName = ""
            }
        }
    }
}

struct FavoriteListRow: View {
    let list: FavoriteList
    
    var body: some View {
        Text(list.name ?? "")
            .font(.headline)
    }
} 