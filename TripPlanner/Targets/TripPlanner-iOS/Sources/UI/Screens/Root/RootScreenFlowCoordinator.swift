import Foundation
import SwiftUI
import TUIService

protocol RootScreenFlowStateProtocol: ObservableObject {
    var route: RootScreenRoute? { get set }
}

enum RootScreenRoute: Identifiable {
    case selectDepartureCity(selected: Binding<City?>, cities: [City])
    case selectDestinationCity(selected: Binding<City?>, cities: [City])
    case connection(_ connection: FlightConnection)

    var modal: Self? {
        return self  // All routes are modals
    }

    var id: String {
        switch self {
        case .selectDepartureCity: return "selectDepartureCity"
        case .selectDestinationCity: return "selectDestinationCity"
        case .connection: return "connection"
        }
    }
}

struct RootScreenFlowCoordinator<
    State: RootScreenFlowStateProtocol,
    Content: View
>: View {

    @ObservedObject var state: State

    let content: () -> Content

    private var activeModal: Binding<RootScreenRoute?> {
        .init {
            state.route?.modal
        } set: { maybeRoute in
            state.route = maybeRoute
        }
    }

    var body: some View {
        content()
            .sheet(item: activeModal, content: routeContent)
    }

    @ViewBuilder
    func routeContent(_ route: RootScreenRoute) -> some View {
        switch route {
        case .selectDepartureCity(let selected, let cities):
            SelectItemScreenView(
                viewModel: .init(title: "Departure", selectedItem: selected, items: cities)
            )
        case .selectDestinationCity(let selected, let cities):
            SelectItemScreenView(
                viewModel: .init(title: "Destination", selectedItem: selected, items: cities)
            )
        case .connection(let connection):
            FlightConnectionDetailView(connection: connection)
        }
    }
}
