import APIKit
import Combine
import Foundation

public enum TUIMobilityHubServiceError: LocalizedError {
  case apiService(APIServiceError)

  public var errorDescription: String? {
    switch self {
    case .apiService(let error): return error.localizedDescription
    }
  }
}

extension Publisher {

  public func mapToTUIError() -> AnyPublisher<Output, TUIMobilityHubServiceError> {
    self
      .mapError { error -> TUIMobilityHubServiceError in
        switch error {
        case let apiError as APIServiceError: return .apiService(apiError)
        default: return .apiService(.unknownError(error))
        }
      }
      .eraseToAnyPublisher()
  }
}
