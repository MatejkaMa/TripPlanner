import MapKit
import SwiftUI
import TUIAPIKit

struct CityConnectionMapView: View {

  let connection: CityConnection

  private var annotationItems: [City] {
    [
      connection.from,
      connection.to,
    ]
  }

  private var mapRect: MKMapRect {
    return [connection.from.coordinate, connection.to.coordinate]
      .map {
        MKMapRect(
          origin: .init(.init(latitude: $0.lat, longitude: $0.long)),
          size: .init(width: 1, height: 1)
        )
      }.reduce(MKMapRect.null) { $0.union($1) }
  }

  var body: some View {
    Map(
      mapRect: .constant(mapRect),
      annotationItems: [
        connection.from,
        connection.to,
      ]
    ) { city in
      MapMarker(
        coordinate: .init(latitude: city.coordinate.lat, longitude: city.coordinate.long),
        tint: city == connection.from ? .blue : .green
      )
    }
  }
}

#if DEBUG
  struct CityConnectionMapView_Previews: PreviewProvider {
    static var previews: some View {
      CityConnectionMapView(connection: .mock)
    }
  }
#endif
