import Foundation

public class Node: Identifiable, Hashable {
    var visited = false
    var connections: [Connection] = []

    public let id: Int

    public init(id: Int) {
        self.id = id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.id == rhs.id
    }
}
