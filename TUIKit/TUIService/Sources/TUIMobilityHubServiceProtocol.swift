import Foundation
import APIService

public protocol TUIMobilityHubServiceProtocol: APIServiceProtocol {}

extension TUIMobilityHubServiceProtocol {

    public func fetchFlightConnections() -> Single<[FlightConnection], TUIMobilityHubServiceError> {
        requestTUI(.connections, model: FlightConnectionJSON.self)
            .map { $0.connections }
            .asSingle()
    }

    public func requestTUI<T: Decodable>(_ request: TUIMobilityRequest, model: T.Type) -> Single<
        T, TUIMobilityHubServiceError
    > {
        return self.request(request, model: model)
            .mapToTUIError()
            .asSingle()
    }
}
