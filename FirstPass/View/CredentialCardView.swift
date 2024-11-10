import SwiftUI

// MARK: - CredentialCardView

struct CredentialCardView: View {

    // MARK: View state

    @State var credential: Credential

    @State private var isPasswordHidden: Bool = true
    @State private var disableDeleteButton: Bool = true

    // MARK: Properties

    private(set) var onDelete: () -> Void

    // MARK: Body

    var body: some View {
        ZStack(alignment: .topTrailing) {

            Button {
                onDelete()
            } label: {
                Image(systemName: "x.circle.fill")
                    .padding(6)
            }
            .padding()
            .zIndex(1)
            .disabled(disableDeleteButton)
            .opacity(disableDeleteButton ? 0 : 1)
            .buttonStyle(.plain)

            cardContentView
                .lineLimit(1)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.background)
                )
                .frame(minWidth: 80, maxWidth: 240, minHeight: 60)
                .padding()
        }
        .onHover { withinBounds in
            disableDeleteButton = !withinBounds
        }
    }
}

// MARK: - Helper Views

private extension CredentialCardView {
    private var cardContentView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(credential.name)
                .font(.headline)
                .bold()
                .foregroundStyle(.primary)

            Text(credential.urlString)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                Text(credential.username)
                    .font(.subheadline)
                    .bold()

                Spacer()

                if isPasswordHidden {
                    obscuredPasswordView
                        .textSelection(.disabled)
                } else {
                    Text(credential.password)
                        .font(.subheadline)
                }

                Button(action: {
                    isPasswordHidden.toggle()
                }) {
                    Image(systemName: isPasswordHidden ? "eye.slash" : "eye")
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .textSelection(.enabled)
        }
    }

    private var obscuredPasswordView: some View {
        Text("********")
            .font(.subheadline)
    }
}

// MARK: - SwiftUI Previews

#Preview {
    CredentialCardView(credential: .mock(), onDelete: { })
}
