import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {
    @AppStorage(AppStorageKey.appAuthenticationEnabled.rawValue) private var appAuthentication: Bool = true

    var body: some View {
        TabView {
            Form {
                Toggle("Use biometry/companion authentication", isOn: $appAuthentication)
            }
            .tabItem {
                Label("General", systemImage: "gear")
            }
        }
        .scenePadding()
        .frame(maxWidth: 350, maxHeight: 150)
    }
}

// MARK: - SwiftUI Previews

#Preview {
    SettingsView()
}
