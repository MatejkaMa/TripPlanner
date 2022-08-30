import Foundation

public protocol APIServiceProtocol {
    func request(_ request: Request) -> Single<Data, APIServiceError>
    init()
}

extension APIServiceProtocol {
    public func request<T: Decodable>(_ request: Request, model: T.Type) -> Single<
        T, APIServiceError
    > {
        self.request(request)
            .tryMap { data -> T in
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch let error {
                    throw APIServiceError.decodingFailed(error)
                }
            }
            .mapToAPIError()
            .asSingle()
    }
}
