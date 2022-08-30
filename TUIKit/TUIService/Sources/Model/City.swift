import Foundation

public struct City: Identifiable, Hashable, Decodable {

    public let name: String
    public let coordinate: FlightConnection.Coordinate

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(coordinate)
    }

    public var id: Int {
        hashValue
    }

    public init(name: String, coordinate: FlightConnection.Coordinate) {
        self.name = name
        self.coordinate = coordinate
    }
}
