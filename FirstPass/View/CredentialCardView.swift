import SwiftUI

// MARK: - CredentialCardView

/// A view representing a card displaying credential information with a delete button.
/// This view displays a single credential in a card layout with a delete button in the top-right corner.
struct CredentialCardView: View {

    // MARK: Internal

    static let minWidth: CGFloat = 100
    static let maxWidth: CGFloat = 240

    @State var credential: Credential
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
            .zIndex(1)
            .disabled(disableDeleteButton)
            .opacity(disableDeleteButton ? 0 : 1)
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)

            cardContentView
                .lineLimit(1)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.background)
                )
                .frame(minWidth: 80, maxWidth: 240, minHeight: 60)
        }
        .onHover { withinBounds in
            disableDeleteButton = !withinBounds
        }
    }

    // MARK: Private 

    @State private var isPasswordHidden: Bool = true
    @State private var disableDeleteButton: Bool = true
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
                    .bold()

                Spacer()

                Group {
                    if isPasswordHidden {
                        Text("********")
                            .textSelection(.disabled)
                    } else {
                        Text(credential.password)
                    }
                }

                Button(action: {
                    isPasswordHidden.toggle()
                }) {
                    Image(systemName: isPasswordHidden ? "eye.slash" : "eye")
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .font(.subheadline)
            .lineLimit(1)
            .textSelection(.enabled)
        }
    }
}

// MARK: - SwiftUI Previews

#Preview {
    CredentialCardView(credential: .mock(), onDelete: { })
}
