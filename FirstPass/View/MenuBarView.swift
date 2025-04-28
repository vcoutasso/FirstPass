import SwiftUI

// MARK: - MenuBarView

struct MenuBarView: View {

    @State private var searchQuery: String = ""
    @State private var selectedIndex: Int? = nil
    @State private var showCopiedPopover: Bool = false
    @FocusState private var searchFieldFocused: Bool
    @EnvironmentObject private var credentialsRepository: CredentialsRepository

    var filteredCredentials: [Credential] {
        if searchQuery.isEmpty {
            Array(credentialsRepository.credentials)
        } else {
            credentialsRepository.credentials.filter { $0.urlString.localizedCaseInsensitiveContains(searchQuery) }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("Search...", text: $searchQuery)
                .textFieldStyle(.plain)
                .padding()
                .focused($searchFieldFocused)
                .onChange(of: searchQuery) {
                    selectedIndex = searchQuery.isEmpty || filteredCredentials.isEmpty ? nil : 0
                }
                .onSubmit {
                    if let index = selectedIndex ?? (filteredCredentials.isEmpty ? nil : 0) {
                        copyPassword(for: filteredCredentials[index])
                    }
                }
                .onAppear {
                    NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { event in
                        handleKeyEvent(event)
                        return event
                    }
                }

            if filteredCredentials.isEmpty {
                ContentUnavailableView.search
            } else {
                List {
                    ForEach(Array(filteredCredentials.enumerated()), id: \.element) { index, credential in
                        Text(credential.urlString)
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                selectedIndex == index ? Color.accentColor.opacity(0.2) : Color.clear
                            )
                            .cornerRadius(6)
                    }
                }
                .listStyle(.plain)
                .frame(maxHeight: 300)
            }
        }
        .animation(.default, value: searchQuery)
        .frame(idealWidth: 150, maxWidth: 250)
        .padding(.bottom)
        .popover(isPresented: $showCopiedPopover) {
            Text("Password copied!")
                .padding()
                .frame(width: 180)
        }
        .onAppear {
            searchFieldFocused = true
        }
    }

    private func handleKeyEvent(_ event: NSEvent) {
        guard searchFieldFocused else { return }

        switch event.keyCode {
            case 125: // Down arrow
                if filteredCredentials.isEmpty { return }
                if let current = selectedIndex {
                    selectedIndex = min(current + 1, filteredCredentials.count - 1)
                } else {
                    selectedIndex = 0
                }
            case 126: // Up arrow
                if filteredCredentials.isEmpty { return }
                if let current = selectedIndex {
                    selectedIndex = max(current - 1, 0)
                } else {
                    selectedIndex = 0
                }
            case 53: // Escape key
                selectedIndex = nil
            default:
                break
        }
    }

    private func copyPassword(for credential: Credential) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(credential.password, forType: .string)

        showCopiedPopover = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showCopiedPopover = false
        }
    }
}

#Preview {
    MenuBarView()
}
