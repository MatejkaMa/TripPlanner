import Foundation

class Graph<Item: Identifiable & Hashable> where Item.ID == Int {

    typealias Connections = [Item: [(to: Item, weight: Int)]]

    let nodes: [Node]

    init(connections: Connections) {
        let nodes = Set(
            connections.flatMap { from, connections in
                [from] + connections.map { $0.to }
            }
        ).map { Node(id: $0.id) }

        connections
            .forEach { fromItem, connections in
                connections.forEach { connection in
                    let toItem = connection.to
                    let weight = connection.weight
                    Graph<Item>.node(for: fromItem, in: nodes).connections.append(.init(to: Graph<Item>.node(for: toItem, in: nodes), weight: weight))
                }
            }
        self.nodes = nodes
    }

    func node(for item: Item) -> Node {
        Self.node(for: item, in: nodes)
    }

    static func node(for item: Item, in nodes: [Node]) -> Node {
        nodes.first(where: { $0.id == item.id }) ?? Node(id: item.id)
    }

}

extension Graph {

    // NOTE: Inspired https://www.fivestars.blog/articles/dijkstra-algorithm-swift/
    /// Used Dijkstra’s algorithm
    func shortestPath(from fromItem: Item, to toItem: Item) -> Path? {

        let source = node(for: fromItem)
        let destination = node(for: toItem)
        var frontier: [Path] = [] {
            didSet { frontier.sort { return $0.cumulativeWeight < $1.cumulativeWeight } } // the frontier has to be always ordered
        }

        frontier.append(Path(to: source)) // the frontier is made by a path that starts nowhere and ends in the source

        while !frontier.isEmpty {
            let cheapestPathInFrontier = frontier.removeFirst() // getting the cheapest path available
            guard !cheapestPathInFrontier.node.visited else { continue } // making sure we haven't visited the node already

            if cheapestPathInFrontier.node === destination {
                return cheapestPathInFrontier // found the cheapest path 😎
            }

            cheapestPathInFrontier.node.visited = true

            for connection in cheapestPathInFrontier.node.connections where !connection.to.visited { // adding new paths to our frontier
                frontier.append(Path(to: connection.to, via: connection, previousPath: cheapestPathInFrontier))
            }
        } // end while
        return nil // we didn't find a path 😣
    }
}
