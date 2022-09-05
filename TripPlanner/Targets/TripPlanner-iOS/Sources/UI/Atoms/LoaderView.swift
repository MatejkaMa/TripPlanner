import SwiftUI

public typealias LoadingView = () -> AnyView

public struct LoaderView<Data, Content: View>: View {

  private let requestState: RequestState<Data>
  private let renderLoadingContentOnNotAskedState: Bool
  private let onNotAsked: () -> Void
  private let onErrorAppear: () -> Void
  private let onErrorAction: () -> Void
  private let loadingView: LoadingView
  private let renderView: (Data) -> Content

  public init(
    requestState: RequestState<Data>,
    renderLoadingContentOnNotAskedState: Bool = true,
    onNotAsked: @escaping () -> Void = {},
    onErrorAppear: @escaping () -> Void = {},
    onErrorAction: @escaping () -> Void = {},
    loadingView: LoadingView? = nil,
    @ViewBuilder renderView: @escaping (Data) -> Content
  ) {
    self.requestState = requestState
    self.renderLoadingContentOnNotAskedState =
      renderLoadingContentOnNotAskedState
    self.onNotAsked = onNotAsked
    self.onErrorAppear = onErrorAppear
    self.onErrorAction = onErrorAction
    self.loadingView = loadingView ?? { Self.loadingView.eraseToAnyView() }
    self.renderView = renderView
  }

  public var body: some View {
    self.contentView()
  }

  @ViewBuilder
  public static var loadingView: some View {
    ProgressView()
      .progressViewStyle(.circular)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private func contentView() -> AnyView {
    switch requestState {
    case .notAsked:
      let view =
        renderLoadingContentOnNotAskedState
        ? loadingView() : Color.clear.eraseToAnyView()
      return
        view
        .onAppear { onNotAsked() }
        .eraseToAnyView()

    case let .loading(last: maybeData):
      guard let data = maybeData else {
        return loadingView()
      }
      return renderView(data).eraseToAnyView()

    case .failure(let error):
      return ErrorView(
        error: error,
        action: {
          onErrorAction()
          onNotAsked()
        }
      )
      .frame(maxHeight: .infinity)
      .onAppear { onErrorAppear() }
      .eraseToAnyView()

    case .success(let data):
      return renderView(data).eraseToAnyView()
    }
  }
}
