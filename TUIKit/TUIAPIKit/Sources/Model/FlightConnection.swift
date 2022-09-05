import Foundation

public struct FlightConnectionJSON: Decodable {
  let connections: [FlightConnection]
}

public struct FlightConnection: Hashable, Identifiable {

  public let from: City
  public let to: City
  public let coordinates: Coordinates
  public let price: Int

  public func hash(into hasher: inout Hasher) {
    hasher.combine(from)
    hasher.combine(from)
    hasher.combine(coordinates)
    hasher.combine(price)
  }

  public var id: Int {
    hashValue
  }

  enum CodingKeys: String, CodingKey {
    case from
    case to
    case coordinates
    case price
  }

  public init(from: City, to: City, coordinates: FlightConnection.Coordinates, price: Int) {
    self.from = from
    self.to = to
    self.coordinates = coordinates
    self.price = price
  }
}

extension FlightConnection: Decodable {

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    self.coordinates = try values.decode(Coordinates.self, forKey: .coordinates)

    let fromName = try values.decode(String.self, forKey: .from)
    self.from = .init(name: fromName, coordinate: coordinates.from)

    let toName = try values.decode(String.self, forKey: .to)
    self.to = .init(name: toName, coordinate: coordinates.to)

    self.price = try values.decode(Int.self, forKey: .price)
  }

}

extension FlightConnection {

  public struct Coordinates: Decodable, Hashable, Identifiable {

    public let from: Coordinate
    public let to: Coordinate

    public func hash(into hasher: inout Hasher) {
      hasher.combine(from)
      hasher.combine(to)
    }

    public var id: Int {
      hashValue
    }

    public init(from: FlightConnection.Coordinate, to: FlightConnection.Coordinate) {
      self.from = from
      self.to = to
    }
  }

  public struct Coordinate: Decodable, Hashable, Identifiable {

    public let lat: Double
    public let long: Double

    public var id: Int {
      hashValue
    }

    public init(lat: Double, long: Double) {
      self.lat = lat
      self.long = long
    }
  }
}

#if DEBUG

  extension FlightConnection {
    public static var mock: FlightConnection {
      mock(index: 1)
    }

    public static func mock(index: Int) -> FlightConnection {
      let dIndex = Double(index)
      let c1: Coordinate = .init(lat: dIndex, long: dIndex)
      let c2: Coordinate = .init(lat: dIndex + 5, long: dIndex + 5)
      return .init(
        from: .init(name: "City \(index)", coordinate: c1),
        to: .init(name: "City \(index)", coordinate: c2),
        coordinates: .init(from: c1, to: c2),
        price: 100
      )
    }
  }

  extension Array where Element == FlightConnection {
    public static var mock: [FlightConnection] {
      return (0...10).map { FlightConnection.mock(index: $0) }
    }
  }
#endif
