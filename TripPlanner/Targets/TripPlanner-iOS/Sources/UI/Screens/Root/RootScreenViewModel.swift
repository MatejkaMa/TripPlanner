import Combine
import SwiftUI
import TUIAPIKit
import TUIAlgorithmKit

protocol RootScreenViewModelProtocol: ObservableObject {

    var connectionsState: RequestState<[FlightConnection]> { get }
    var selectedDepartureCity: City? { get set }
    var selectedDestinationCity: City? { get set }
    var selectedDepartureCityPublisher: AnyPublisher<City?, Never> { get }
    var selectDestinationCityPublisher: AnyPublisher<City?, Never> { get }

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

    var selectedDepartureCityPublisher: AnyPublisher<City?, Never> {
        $selectedDepartureCity.eraseToAnyPublisher()
    }

    var selectDestinationCityPublisher: AnyPublisher<City?, Never> {
        $selectedDestinationCity.eraseToAnyPublisher()
    }

    @Published var connectionsState: RequestState<[FlightConnection]> = .notAsked
    @Published var selectedDepartureCity: City?
    @Published var selectedDestinationCity: City?

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
