import SwiftUI

// MARK: - CredentialEditView

struct CredentialEditView: View {

    // MARK: Internal

    @State var credential: Credential
    @Environment(\.dismiss) private var dismiss

    private(set) var onSave: ((Credential) -> Void)

    // MARK: Body

    var body: some View {
        Form {
            inputField(label: "Name:", text: $credential.name)

            inputField(label: "Username:", text: $credential.username, contentType: .username)

            inputField(label: "Password:", text: $credential.password, contentType: .password)

            inputField(label: "URL:", text: $credential.urlString, contentType: .URL)

            HStack(spacing: 20) {
                Spacer()

                Button("Cancel") {
                    dismiss()
                }

                Button("Save") {
                    onSave(credential)
                    dismiss()
                }
                .disabled(!credential.isValid())
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .padding(.vertical)
    }
}

// MARK: Helper views

private extension CredentialEditView {
    @ViewBuilder
    private func inputField(label: String, text: Binding<String>, contentType: NSTextContentType? = nil) -> some View  {
        TextField(label, text: text)
            .textContentType(contentType)
            .autocorrectionDisabled()
            .padding(.horizontal)
    }
}

// MARK: SwiftUI previews

#Preview("Create credential") {
    var credential = Credential.emptyCredential()
    CredentialEditView(credential: credential, onSave: { _ in })
}

#Preview("Update credential") {
    var credential = Credential.mock()
    CredentialEditView(credential: credential, onSave: { _ in })
}
