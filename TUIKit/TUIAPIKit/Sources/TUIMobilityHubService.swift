import APIKit
import Combine
import Foundation

public final class TUIMobilityHubService: APIService<TUIMobilityRequest>,
    TUIMobilityHubServiceProtocol
{}

#if DEBUG

    public final class MockTUIMobilityHubService: MockAPIService<TUIMobilityRequest>,
        TUIMobilityHubServiceProtocol
    {
        public required init() {}
    }

#endif
