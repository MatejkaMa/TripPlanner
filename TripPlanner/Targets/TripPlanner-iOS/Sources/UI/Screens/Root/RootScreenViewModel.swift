import Combine
import SwiftUI
import TUIAPIKit
import TUIAlgorithmKit

protocol RootScreenViewModelProtocol: ObservableObject {

    var connectionsState: RequestState<[FlightConnection]> { get }
    var sortedConnections: [FlightConnection] { get }
    var selectedDepartureCity: City? { get set }
    var selectedDestinationCity: City? { get set }

    var cities: [City] { get }

    func fetchFlightConnections()
}

final class RootScreenViewModel: RootScreenViewModelProtocol, RootScreenFlowStateProtocol {

    // MARK: - Private props

    private let tuiService: TUIMobilityHubServiceProtocol
    private var cancelables: Set<AnyCancellable> = Set()

    init(tuiService: TUIMobilityHubServiceProtocol) {
        self.tuiService = tuiService
        fetchFlightConnections()
    }

    // MARK: - View Model -

    // MARK: - Public props

    /// Cheapest
    var sortedConnections: [FlightConnection] {
        connections.sorted(by: { $0.price < $1.price })
    }

    @Published var connectionsState: RequestState<[FlightConnection]> = .notAsked
    @Published var selectedDepartureCity: City?
    @Published var selectedDestinationCity: City? {
        didSet {
            guard let source = selectedDepartureCity,
                  let destination = selectedDestinationCity else {
                      return
                  }
            printCheapestRoute(source, destination: destination)
        }
    }

    var cities: [City] {
        guard case .success(let connections) = connectionsState else { return [] }
        let mergedDeparturesAndDestinations =
            connections.map { $0.from } + connections.map { $0.to }
        let uniqueCities = Set(mergedDeparturesAndDestinations)
        return Array(uniqueCities)
    }

    // MARK: - Private props

    private var connections: [FlightConnection] {
        guard case .success(let connections) = connectionsState else { return [] }
        return connections
    }

    // MARK: - Public methods

    func fetchFlightConnections() {
        connectionsState = .loading(last: [])
        tuiService
            .fetchFlightConnections()
            .catchToResult()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let connections):
                    self?.connectionsState = .success(connections)
                case .failure(let error):
                    self?.connectionsState = .failure(error)
                }
            }
            .store(in: &cancelables)
    }

    func printCheapestRoute(_ source: City, destination: City) {
        let graph = CityGraph(connections: connections)
        if let path = graph.cheapestPath(from: source, to: destination) {
            let citiesNames = path.array.reversed()
                .compactMap { node in
                    return cities.first { city in
                        return city.id == node.id
                    }
                }
                .map { $0.name}
            print("🏁 Quickest path: \(citiesNames), for: \(path.cumulativeWeight)\n connections: \(path.connections.map { $0.weight })")
        } else {
            print("💥 No path between \(source.name) & \(destination.name)")
        }
    }

    // MARK: - Flow state -

    @Published var route: RootScreenRoute?

}

extension City: ListItem {
    var title: String {
        return name
    }
}

#if DEBUG

    extension RootScreenViewModel {
        static var preview: RootScreenViewModel {
            return .init(tuiService: MockTUIMobilityHubService())
        }
    }

#endif
