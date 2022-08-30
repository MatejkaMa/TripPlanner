import SwiftUI
import TUIService

struct FlightConnectionsList<Header: View>: View {

    let connections: [FlightConnection]
    let departure: City?
    let destination: City?
    let onSelect: (FlightConnection) -> Void
    let header: () -> Header

    private var filteredConnections: [FlightConnection] {
        connections.filter {
            switch (departure, destination) {
            case (nil, nil): return true
            case (.some(let departure), .some(let destination)):
                return $0.from == departure && $0.to == destination
            case (.some(let departure), nil):
                return $0.from == departure
            case (_, .some(let destination)):
                return $0.to == destination
            }
        }
    }

    var body: some View {
        List {
            Section {
                ForEach(filteredConnections, id: \.self, content: connectionCell)
            } header: {
                header()
            }
        }
        .listStyle(.plain)
        .animation(.default, value: filteredConnections)
    }

    private func connectionCell(_ connection: FlightConnection) -> some View {
        Button {
            onSelect(connection)
        } label: {
            connectionCellLabel(connection)
        }

    }

    private func connectionCellLabel(_ connection: FlightConnection) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("From: **\(connection.from.title)**")
                    .font(.caption)
                Text("To: **\(connection.to.title)**")
                    .font(.caption)
            }
            Spacer()
            Text("\(connection.price) 💵")
                .font(.headline)
                .fontWeight(.medium)
        }
    }
}

#if DEBUG
    struct FlightConnectionsList_Previews: PreviewProvider {

        static var previews: some View {
            FlightConnectionsList(
                connections: .mock,
                departure: nil,
                destination: nil,
                onSelect: { _ in },
                header: { Text("Sticky Header") }
            )
        }
    }
#endif
