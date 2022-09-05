import Foundation
import TUIAPIKit

public final class CityNode: Nodalbe {
    public var visited: Bool = false

    public var connections: [Connection<CityNode>] = []

    public var item: City

    public required init(_ item: City) {
        self.item = item
    }
}
