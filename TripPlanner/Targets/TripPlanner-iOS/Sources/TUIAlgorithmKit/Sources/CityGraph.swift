import Foundation
import TUIService

class CityGraph: Graph<City> {

    init(connections: [FlightConnection]) {
        let connections = Dictionary(grouping: connections) { connection -> City in
            connection.from
        }.mapValues { connections in
            connections.map { ($0.to, $0.price) }
        }
        super.init(connections: connections)
    }

    func cheapestPath(from source: City, to destination: City) -> Path? {
        shortestPath(from: source, to: destination)
    }

}
