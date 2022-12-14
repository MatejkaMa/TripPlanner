import Foundation

public protocol Nodalbe: AnyObject, Identifiable, Hashable {
    associatedtype Item: Identifiable & Hashable
    var visited: Bool { get set }
    var connections: [Connection<Self>] { get set }

    var item: Item { get }

    init(_ item: Item)
}

extension Nodalbe {
    public var id: Item.ID {
        return item.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

//public class Node: Identifiable, Hashable {
//    var visited = false
//    var connections: [Connection] = []
//
//    public let id: Int
//
//    public init(id: Int) {
//        self.id = id
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//
//    public static func == (lhs: Node, rhs: Node) -> Bool {
//        lhs.id == rhs.id
//    }
//}
