import SwiftUI
import TUIAPIKit

struct SelectItemView<Item: ListItem>: View {

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    @StateObject var viewModel: SelectItemViewModel<Item>

    var body: some View {
        NavigationView {
            List(viewModel.filteredItems, id: \.self, rowContent: rowContent)
                .listStyle(.inset)
                .searchable(
                    text: $viewModel.searchQuery,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Find city"
                ) {
                    ForEach(viewModel.filteredItems) { item in
                        rowContent(item)
                    }
                }
                .navigationViewStyle(.stack)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(viewModel.title)
        }
    }

    private func rowContent(_ item: Item) -> some View {
        Button(
            action: {
                viewModel.selectedItem.wrappedValue = item
                presentationMode.wrappedValue.dismiss()
            },
            label: {
                rowLabel(item)
            }
        )
    }

    private func rowLabel(_ item: Item) -> some View {
        HStack {
            if let city = item as? City {
                CityMapView(city: city)
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
                    .disabled(true)
            } else {
                Image(systemName: "building.2.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }

            Text(verbatim: item.title)

            Spacer()

            if viewModel.selectedItem.wrappedValue == item {
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
            }
        }
        .frame(height: 80)
    }
}

struct SelectCityScreenView_Previews: PreviewProvider {
    struct MockListItem: ListItem {
        let title: String
        let description: String

        var id: String {
            return title
        }

        static var mockItems: [MockListItem] {
            (0...10).map { MockListItem(title: "\($0)", description: "Description") }
        }
    }

    static var previews: some View {
        SelectItemView<MockListItem>(viewModel:
                .init(
                    title: "Title",
                    selectedItem: .constant(nil),
                    items: MockListItem.mockItems
                )
        )
    }
}
