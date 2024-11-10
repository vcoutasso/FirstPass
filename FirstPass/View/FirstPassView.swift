import SwiftUI

// MARK: - FirstPassView

struct FirstPassView: View {

    // MARK: Lifecycle

    init(viewModel: FirstPassViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Body

    var body: some View {
        CredentialGridView(credentials: $viewModel.credentials)
    }

    // MARK: Private properties

    @StateObject private var viewModel: FirstPassViewModel

}

// MARK: - SwiftUI Previews

#Preview {
    let credentials: [Credential] = {
        var array = [Credential]()
        for _ in 1...10 { array.append(.mock()) }
        return array
    }()
    let vm = FirstPassViewModel(credentials: Set(credentials))

    FirstPassView(viewModel: vm)
        .frame(width: 800, height: 640)
}
