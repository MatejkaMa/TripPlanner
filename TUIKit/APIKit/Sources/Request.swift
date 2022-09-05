import Foundation

public protocol Request {
  var baseURL: URL { get }
  var method: RequestMethod { get }
  var path: String { get }
  var sampleData: Data { get }
}

public enum RequestMethod: String {
  case GET
}
