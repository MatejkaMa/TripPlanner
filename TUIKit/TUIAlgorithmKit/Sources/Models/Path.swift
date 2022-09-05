import Foundation

public class Path<Node: Nodalbe> {
    public let cumulativeWeight: Int
    public let node: Node
    public let previousPath: Path?
    private let connection: Connection<Node>?

    public init(
        to node: Node,
        via connection: Connection<Node>? = nil,
        previousPath path: Path<Node>? = nil
    ) {
        if let previousPath = path,
            let viaConnection = connection
        {
            self.cumulativeWeight = viaConnection.weight + previousPath.cumulativeWeight
        } else {
            self.cumulativeWeight = 0
        }
        self.node = node
        self.previousPath = path
        self.connection = connection
    }
}

extension Path {

    public var paths: [Path<Node>] {
        var array: [Path<Node>] = [self]
        var iterativePath = self
        while let path = iterativePath.previousPath {
            array.append(path)
            iterativePath = path
        }
        return array
    }

    public var array: [Node] {
        paths.map { $0.node }
    }

    public var connections: [Connection<Node>] {
        paths.compactMap { $0.connection }
    }
}
