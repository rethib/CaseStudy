// This is a source file for the MovieList target. Make sure it's included in the Xcode project and build target.

import SwiftUI

struct FavoriteListSelectionView: View {
    @StateObject private var viewModel = FavoriteListsViewModel()
    @State private var showingNewListSheet = false
    @State private var newListName = ""
    @Environment(\.dismiss) private var dismiss
    
    let onSelect: (FavoriteList) -> Void
    
    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.lists.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    Text(LocalizationKey.Favorites.Lists.noLists.localized)
                        .font(.title3)
                        .bold()
                    Text(LocalizationKey.Favorites.Lists.createListMessage.localized)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Button(LocalizationKey.Favorites.Lists.createList.localized) {
                        showingNewListSheet = true
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ForEach(viewModel.lists) { list in
                    Button {
                        onSelect(list)
                    } label: {
                        HStack {
                            Text(list.name ?? "")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(LocalizationKey.Favorites.Lists.addToList.localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingNewListSheet = true
                } label: {
                    Label(LocalizationKey.Favorites.Lists.new.localized, systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingNewListSheet) {
            NavigationStack {
                Form {
                    Section {
                        TextField(LocalizationKey.Favorites.Lists.name.localized, text: $newListName)
                    }
                }
                .navigationTitle(LocalizationKey.Favorites.Lists.new.localized)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(LocalizationKey.Common.cancel.localized) {
                            showingNewListSheet = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(LocalizationKey.Common.create.localized) {
                            Task {
                                await viewModel.createList(name: newListName)
                                showingNewListSheet = false
                                newListName = ""
                            }
                        }
                        .disabled(newListName.isEmpty)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .presentationDetents([.height(200)])
        }
        .task {
            await viewModel.loadLists()
        }
    }
} 