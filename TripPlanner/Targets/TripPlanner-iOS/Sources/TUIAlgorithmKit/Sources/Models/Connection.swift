import Foundation

class Connection {
    public let to: Node
    public let weight: Int

    public init(to node: Node, weight: Int) {
        assert(weight >= 0, "weight has to be equal or greater than zero")
        self.to = node
        self.weight = weight
    }
}
