import MapKit
import SwiftUI
import TUIAPIKit

struct CityMapView: View {

    let city: City

    private var region: MKCoordinateRegion {
        return .init(
            center: .init(latitude: city.coordinate.lat, longitude: city.coordinate.long),
            span: .init(latitudeDelta: 15, longitudeDelta: 15)
        )
    }

    var body: some View {
        Map(
            coordinateRegion: .constant(region),
            annotationItems: [city]
        ) { _ in
            MapMarker(
                coordinate: .init(latitude: city.coordinate.lat, longitude: city.coordinate.long),
                tint: Color.blue
            )
        }
    }
}

struct CityMapView_Previews: PreviewProvider {
    static var previews: some View {
        CityMapView(city: .mock)
    }
}
