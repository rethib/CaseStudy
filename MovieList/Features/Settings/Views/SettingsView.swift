import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section(LocalizationKey.Settings.appInfo.localized) {
                HStack {
                    Text(LocalizationKey.Settings.version.localized)
                    Spacer()
                    Text(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0")
                        .foregroundColor(.secondary)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(LocalizationKey.Settings.title.localized)
                    .font(.headline)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
} 