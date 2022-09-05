import APIKit
import Foundation

public enum TUIMobilityRequest: Request {
  case connections

  public var baseURL: URL {
    return URL(string: "https://raw.githubusercontent.com/TuiMobilityHub")!
  }

  public var method: RequestMethod {
    switch self {
    case .connections: return .GET
    }
  }

  public var path: String {
    switch self {
    case .connections: return "ios-code-challenge/master/connections.json"
    }
  }

  public var sampleData: Data {
    switch self {
    case .connections:
      guard
        let file = Bundle.module.url(
          forResource: "FlightConnectionsJSON",
          withExtension: "json"
        )
      else { return Data() }
      do {
        return try Data(contentsOf: file)
      } catch {
        return Data()
      }
    }
  }

}
