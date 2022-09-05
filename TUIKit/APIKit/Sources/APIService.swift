import Combine
import Foundation

open class APIService<R: Request>: APIServiceProtocol {
  public func request(_ request: Request) -> Single<Data, APIServiceError> {
    let requestURL = request.baseURL.appendingPathComponent(request.path)
    var urlRequest = URLRequest(url: requestURL)
    urlRequest.httpMethod = request.method.rawValue
    return URLSession.shared.dataTaskPublisher(for: urlRequest)
      .map(\.data)
      .mapToAPIError()
      .asSingle()
  }

  required public init() {}
}

#if DEBUG

  open class MockAPIService<R: Request>: APIServiceProtocol {
    public func request(_ request: Request) -> Single<Data, APIServiceError> {
      Just(request.sampleData)
        .setFailureType(to: APIServiceError.self)
        .asSingle()
    }

    required public init() {}
  }

#endif
