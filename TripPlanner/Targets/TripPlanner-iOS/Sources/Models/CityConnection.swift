import Foundation
import TUIAPIKit
import TUIAlgorithmKit

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

extension CityConnection {
    static var mock: CityConnection {
        return .init(
            from: .init(name: "London", coordinate: .init(lat: 1, long: 1)),
            to: .init(name: "LA", coordinate: .init(lat: 1.5, long: 1.5)),
            price: 200,
            children: nil
        )
    }
}

extension Sequence where Element == CityConnection {
    static var mock: [CityConnection] {
        [
            .init(
                from: .init(name: "London", coordinate: .init(lat: 0, long: 0)),
                to: .init(name: "LA", coordinate: .init(lat: 1, long: 1)),
                price: 100,
                children: [
                    .init(
                        from: .init(name: "London", coordinate: .init(lat: 0, long: 0)),
                        to: .init(name: "New York", coordinate: .init(lat: 0.5, long: 0.5)),
                        price: 80,
                        children: nil
                    )
                ]
            ),
            .mock
        ]
    }
}

