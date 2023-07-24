import Foundation
import TUIAPIKit

public class CityGraph: Graph<CityNode> {

    public init(
        connections: [FlightConnection]
    ) {
        let connections = Dictionary(grouping: connections) { connection -> City in
            connection.from
        }.mapValues { connections in
            connections.map { ($0.to, $0.price) }
        }
        super.init(connections: connections)
    }

    public func cheapestPath(
        from source: City,
        to destination: City
    ) -> Path<CityNode>? {
        shortestPath(from: source, to: destination)
    }

}
