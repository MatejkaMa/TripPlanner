import Combine
import SwiftUI

protocol ListItem: Identifiable, Hashable {
    var title: String { get }
    var description: String { get }
}

final class SelectItemViewModel<Item: ListItem>: ObservableObject {

    // MARK: - Public props

    @Published var searchQuery: String = ""

    let title: String
    var selectedItem: Binding<Item?>

    var filteredItems: [Item] {
        guard !searchQuery.isEmpty else {
            return items
        }
        return items.filter { item in
            item.title.lowercased().contains(searchQuery.lowercased())
        }
    }

    // MARK: - Private props

    private let items: [Item]
    private var cancelables: Set<AnyCancellable> = Set()

    // MARK: - Constructors

    init(title: String, selectedItem: Binding<Item?>, items: [Item]) {
        self.title = title
        self.selectedItem = selectedItem
        let sortedItems = items.sorted(by: { first, second in
            first.title < second.title
        })
        self.items = sortedItems
    }
}
