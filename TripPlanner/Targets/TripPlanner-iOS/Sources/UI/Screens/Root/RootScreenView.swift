import SwiftUI

struct RootScreenView<
    ViewModel: RootScreenViewModelProtocol & RootScreenFlowStateProtocol
>: View {

    @StateObject var viewModel: ViewModel

    private var departureText: String {
        guard let departure = viewModel.selectedDepartureCity else {
            return "Select departure"
        }
        return departure.title
    }

    private var destinationText: String {
        guard let destination = viewModel.selectedDestinationCity else {
            return "Select destination"
        }
        return destination.title
    }

    var body: some View {
        RootScreenFlowCoordinator(state: viewModel, content: content)
    }

    func content() -> some View {
        NavigationView {
            LoaderView(
                requestState: viewModel.connectionsState,
                onNotAsked: { viewModel.fetchFlightConnections() }
            ) { connections in
                if connections.isEmpty {
                    Text("No flight connections")
                } else {
                    FlightConnectionsList(viewModel: .init(connections, from: viewModel.selectedDepartureCityPublisher, to: viewModel.selectDestinationCityPublisher, onSelect: { connection in
                            viewModel.route = .connection(connection)
                    }), header: connectionCitiesSelectionSection)
                }
            }
            .navigationTitle("Trip")
        }
        .navigationViewStyle(.stack)
        .ignoresSafeArea()
    }

    private func connectionCitiesSelectionSection() -> some View {
        VStack(spacing: 8) {
            selectCityButton(
                title: "From",
                description: departureText,
                action: {
                    viewModel.route = .selectDepartureCity(
                        selected: $viewModel.selectedDepartureCity,
                        cities: viewModel.cities
                    )
                },
                clear: viewModel.selectedDepartureCity == nil
                    ? nil
                    : {
                        viewModel.selectedDepartureCity = nil
                    }
            )

            selectCityButton(
                title: "To",
                description: destinationText,
                action: {
                    viewModel.route = .selectDestinationCity(
                        selected: $viewModel.selectedDestinationCity,
                        cities: viewModel.cities
                    )
                },
                clear: viewModel.selectedDestinationCity == nil
                    ? nil
                    : {
                        viewModel.selectedDestinationCity = nil
                    }
            )
        }
    }

    func selectCityButton(
        title: String,
        description: String,
        action: @escaping () -> Void,
        clear: (() -> Void)?
    ) -> some View {
        Button(
            action: action,
            label: {
                HStack {
                    Text(title)
                    Spacer()
                    Text(description)
                    if let clear = clear {
                        Button(action: clear) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 15, height: 15)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
        )
    }
}


#if DEBUG
    struct RootScreenView_Previews: PreviewProvider {
        static var previews: some View {
            RootScreenView<RootScreenViewModel>(viewModel: .preview)
        }
    }
#endif
