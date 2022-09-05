import Combine
import Foundation

public enum APIServiceError: LocalizedError {
    case responseError(URLSession.DataTaskPublisher.Failure)
    case decodingFailed(Error)
    case unknownError(Error)

    public var errorDescription: String? {
        switch self {
        case .responseError(let error): return "Request data failed: \(error.localizedDescription)"
        case .decodingFailed(let error): return "Decoding failed: \(error.localizedDescription)"
        case .unknownError(let error): return error.localizedDescription
        }
    }
}

extension Publisher {

    public func mapToAPIError() -> AnyPublisher<Output, APIServiceError> {
        self
            .mapError { error -> APIServiceError in
                switch error {
                case let apiError as APIServiceError: return apiError
                case let dataTaskPublisherErr as URLSession.DataTaskPublisher.Failure:
                    return .responseError(dataTaskPublisherErr)
                default: return .unknownError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
