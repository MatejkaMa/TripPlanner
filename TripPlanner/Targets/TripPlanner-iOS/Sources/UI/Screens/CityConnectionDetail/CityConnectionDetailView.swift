import SwiftUI
import TUIAPIKit

struct CityConnectionDetailView: View {

    let connection: CityConnection

    var body: some View {
        VStack {
            HStack {
                description(connection.from)
                Spacer()
                VStack(spacing: 8) {
                    Text("\(connection.price) 💵")
                        .font(.headline)
                        .fontWeight(.medium)
                    Image(systemName: "arrow.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 20)
                }
                Spacer()
                description(connection.to)
            }
            .padding(.horizontal, 30)
            .padding(.vertical)

            CityConnectionMapView(connection: connection)
        }
    }

    private func description(_ city: City) -> some View {
        VStack(alignment: .leading) {
            Text(city.title)
            Text(city.description)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct CityConnectionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CityConnectionDetailView(connection: .mock)
    }
}

