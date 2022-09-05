import Combine
import Foundation
import TUIAPIKit
import TUIAlgorithmKit

final class FlightConnectionsListViewModel: ObservableObject {

    @Published var cityConnections: [CityConnection] = []
    let onSelect: (CityConnection) -> Void

    private let connections: [FlightConnection]
    private let fromPublisher: AnyPublisher<City?, Never>
    private let toPublisher: AnyPublisher<City?, Never>

    private let connectionFindingQueue: DispatchQueue = .init(
        label: "queue.tp.connectionFindingQueue"
    )
    private var cancelables: Set<AnyCancellable> = Set()

    init(
        _ connections: [FlightConnection],
        from: AnyPublisher<City?, Never>,
        to: AnyPublisher<City?, Never>,
        onSelect: @escaping (CityConnection) -> Void
    ) {
        self.connections = connections
        self.fromPublisher = from
        self.toPublisher = to
        self.onSelect = onSelect
        setupSubscriptions()
    }

    private var sortedConnections: [FlightConnection] {
        connections.sorted(by: { $0.price < $1.price })
    }

    private func setupSubscriptions() {

        Publishers.CombineLatest(fromPublisher, toPublisher)
            .receive(on: connectionFindingQueue)
            .map { [weak self] from, to -> [CityConnection] in
                guard let `self` = self else { return [] }
                switch (from, to) {
                case (.some(let city), nil):
                    return self.sortedConnections.filter { $0.from == city }
                        .map {
                            CityConnection(from: $0.from, to: $0.to, price: $0.price, children: nil)
                        }
                case (nil, .some(let city)):
                    return self.sortedConnections.filter { $0.to == city }
                        .map {
                            CityConnection(from: $0.from, to: $0.to, price: $0.price, children: nil)
                        }
                case (.some(let departure), .some(let destination)):
                    return CityGraph(connections: self.connections).cheapestPath(
                        from: departure,
                        to: destination
                    )
                    .map { path in
                        let children: [CityConnection] = {
                            return path.connections.reversed().reduce(into: [CityConnection]()) {
                                partialResult,
                                nodeConnection in
                                if let last = partialResult.last {
                                    partialResult += [
                                        CityConnection(
                                            from: last.to,
                                            to: nodeConnection.to.item,
                                            price: nodeConnection.weight,
                                            children: nil
                                        )
                                    ]
                                } else {
                                    partialResult = [
                                        CityConnection(
                                            from: departure,
                                            to: nodeConnection.to.item,
                                            price: nodeConnection.weight,
                                            children: nil
                                        )
                                    ]
                                }
                            }
                        }()
                        return [
                            CityConnection(
                                from: departure,
                                to: destination,
                                price: path.cumulativeWeight,
                                children: children
                            )
                        ]
                    } ?? []
                case (.none, .none): return []
                }
            }
            .receive(on: DispatchQueue.main)
            .print("Connections")
            .sink { [weak self] connections in
                self?.cityConnections = connections
            }
            .store(in: &cancelables)
    }
}
