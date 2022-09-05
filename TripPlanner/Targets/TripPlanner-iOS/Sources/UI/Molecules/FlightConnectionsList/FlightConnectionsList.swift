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

struct CityConnection: Identifiable, Hashable {
  let from: City
  let to: City
  let price: Int
  let children: [CityConnection]?

  func hash(into hasher: inout Hasher) {
    hasher.combine(from)
    hasher.combine(to)
    hasher.combine(price)
    hasher.combine(children)
  }

  var id: Int {
    hashValue
  }
}

#if DEBUG
  extension CityConnection {
    static var mock: CityConnection {
      return .init(
        from: .init(name: "London", coordinate: .init(lat: 1, long: 1)),
        to: .init(name: "LA", coordinate: .init(lat: 1, long: 1)), price: 200, children: nil)
    }
  }

  extension Sequence where Element == CityConnection {
    static var mock: [CityConnection] {
      [
        .init(
          from: .init(name: "London", coordinate: .init(lat: 0, long: 0)),
          to: .init(name: "LA", coordinate: .init(lat: 1, long: 1)), price: 100,
          children: [
            .init(
              from: .init(name: "London", coordinate: .init(lat: 0, long: 0)),
              to: .init(name: "New York", coordinate: .init(lat: 0.5, long: 0.5)), price: 80,
              children: nil)
          ]),
        .init(
          from: .init(name: "London", coordinate: .init(lat: 1, long: 1)),
          to: .init(name: "LA", coordinate: .init(lat: 1, long: 1)), price: 200, children: nil),
      ]
    }
  }
#endif

struct FlightConnectionsList<Header: View>: View {

  @StateObject var viewModel: FlightConnectionsListViewModel
  let header: () -> Header

  var body: some View {
    List {
      Section {
        OutlineGroup(viewModel.cityConnections, children: \.children, content: connectionCell)
      } header: {
        header()
      }
    }
    .listStyle(.plain)
    .animation(.default, value: viewModel.cityConnections)
  }

  private func connectionCell(_ connection: CityConnection) -> some View {
    Button {
      viewModel.onSelect(connection)
    } label: {
      connectionCellLabel(connection)
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
        viewModel: .init(
          [], from: Just(nil).eraseToAnyPublisher(), to: Just(nil).eraseToAnyPublisher(),
          onSelect: { _ in }),
        header: { Text("Sticky Header") }
      )
    }
  }
#endif
