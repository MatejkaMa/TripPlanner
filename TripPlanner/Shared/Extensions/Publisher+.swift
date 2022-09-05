import Combine
import Foundation

extension Publisher {
    public func catchToResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self
            .map { Result<Output, Failure>.success($0) }
            .catch { Just<Result<Output, Failure>>(.failure($0)) }
            .eraseToAnyPublisher()
    }
}
