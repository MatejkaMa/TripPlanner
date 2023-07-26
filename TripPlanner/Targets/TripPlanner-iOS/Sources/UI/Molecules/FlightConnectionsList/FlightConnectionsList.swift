import Combine
import SwiftUI
import TUIAPIKit
import TUIAlgorithmKit

extension TUIAlgorithmKit.Path: Identifiable where Node == CityNode {
    public var id: CityNode.ID {
        return node.id
    }

    public var children: [TUIAlgorithmKit.Path<CityNode>]? {
        return Array(self.paths.dropFirst())
    }
}

struct FlightConnectionsList<Header: View>: View {

    @StateObject var viewModel: FlightConnectionsListViewModel
    let header: () -> Header

    var body: some View {
        List {
            Section(
                content: {
                    OutlineGroup(
                        viewModel.cityConnections,
                        children: \.children,
                        content: connectionCell
                    )
                },
                header: header
            )
        }
        .listStyle(.plain)
        .animation(.default, value: viewModel.cityConnections)
    }

    @ViewBuilder
    private func connectionCell(_ connection: CityConnection) -> some View {
        if connection.transfers > 0 {
            connectionCellLabel(connection)
        } else {
            Button {
                viewModel.onSelect(connection)
            } label: {
                connectionCellLabel(connection)
            }
        }
    }

    private func connectionCellLabel(_ connection: CityConnection) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("From: **\(connection.from.title)**")
                    .font(.caption)
                Text("To: **\(connection.to.title)**")
                    .font(.caption)
            }
            Spacer()
            if connection.transfers > 0 {
                Text("\(connection.transfers) transfers")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.blue.opacity(0.5))
                    .cornerRadius(8)

            }
            Text("\(connection.price) 💵")
                .font(.headline)
                .fontWeight(.medium)
        }
    }
}


struct FlightConnectionsList_Previews: PreviewProvider {

    static var previews: some View {
        FlightConnectionsList(
            viewModel: .init(
                [],
                from: Just(nil).eraseToAnyPublisher(),
                to: Just(nil).eraseToAnyPublisher(),
                onSelect: { _ in }
            ),
            header: { Text("Sticky Header") }
        )
    }
}

