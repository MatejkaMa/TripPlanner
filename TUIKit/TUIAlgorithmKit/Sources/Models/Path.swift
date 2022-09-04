import Foundation

public class Path {
    public let cumulativeWeight: Int
    public let node: Node
    public let previousPath: Path?
    private let connection: Connection?

    public init(to node: Node, via connection: Connection? = nil, previousPath path: Path? = nil) {
        if
            let previousPath = path,
            let viaConnection = connection {
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
    public var array: [Node] {
        var array: [Node] = [self.node]

        var iterativePath = self
        while let path = iterativePath.previousPath {
            array.append(path.node)
            iterativePath = path
        }

        return array
    }

    public var connections: [Connection] {
        var array: [Connection?] = [connection]

        var iterativePath = self
        while let path = iterativePath.previousPath {
            array.append(path.connection)
            iterativePath = path
        }
        return array.compactMap { $0 }
    }
}
