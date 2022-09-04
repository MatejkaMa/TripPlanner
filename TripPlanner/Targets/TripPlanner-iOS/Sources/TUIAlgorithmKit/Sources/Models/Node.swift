import Foundation

class Node: Identifiable, Hashable {
    var visited = false
    var connections: [Connection] = []

    let id: Int

    init(id: Int) {
        self.id = id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.id == rhs.id
    }
}
