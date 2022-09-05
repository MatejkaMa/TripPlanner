import SwiftUI

public struct ErrorView: View {

    let error: Error
    let action: (() -> Void)

    public init(error: Error, action: @escaping (() -> Void)) {
        self.error = error
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 26) {

                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 54, height: 50)

                VStack(spacing: 16) {

                    Text(verbatim: "Error occurred")
                        .font(.headline)

                    Text(verbatim: error.localizedDescription)
                        .font(.body)
                        .multilineTextAlignment(.center)
                }
            }

            Spacer()

            Button(action: action) {
                Text(verbatim: "Try again")
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
    }
}

// MARK: Preview

#if DEBUG
    struct ErrorView_Previews: PreviewProvider {

        enum ExampleError: LocalizedError {
            case connectionProblem

            var errorDescription: String? {
                switch self {
                case .connectionProblem:
                    return "Connection problem. Please check your internet connection."
                }
            }
        }

        static var previews: some View {
            ErrorView(error: ExampleError.connectionProblem, action: {})
                .previewLayout(.fixed(width: 300, height: 300))
        }
    }

#endif
