import MapKit
import SwiftUI
import TUIAPIKit

struct CityConnectionMapView: View {

    let connection: CityConnection

    private var from: City {
        connection.from
    }

    private var to: City {
        connection.to
    }

    var body: some View {
        Map(
            mapRect: .constant(Self.calculateMapRect(from: .init(from.coordinate), to: .init(to.coordinate))),
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

    static func calculateMapRect(
        from source: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D
    ) -> MKMapRect {
        let mapRect = MKMapRect.world // Start with the whole world as the initial map rect

        // Get the map points for both source and destination coordinates
        let sourceMapPoint = MKMapPoint(source)
        let destinationMapPoint = MKMapPoint(destination)

        // Create a region that contains both points
        let mapRectContainingPoints = MKMapRect(x: min(sourceMapPoint.x, destinationMapPoint.x),
                                                y: min(sourceMapPoint.y, destinationMapPoint.y),
                                                width: abs(sourceMapPoint.x - destinationMapPoint.x),
                                                height: abs(sourceMapPoint.y - destinationMapPoint.y))

        // Center the map rect
        let mapRectCentered = MKMapRect(x: mapRectContainingPoints.midX - mapRect.width / 2,
                                        y: mapRectContainingPoints.midY - mapRect.height / 2,
                                        width: mapRect.width,
                                        height: mapRect.height)

        return mapRectCentered
    }
}

extension CLLocationCoordinate2D {
    init(_ coordinate: FlightConnection.Coordinate) {
        self.init(latitude: coordinate.lat, longitude: coordinate.long)
    }
}

struct CityConnectionMapView_Previews: PreviewProvider {
    static var previews: some View {
        CityConnectionMapView(connection: .mock)
    }
}
