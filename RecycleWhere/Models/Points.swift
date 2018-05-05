import Foundation
import MapKit
import Contacts
import CoreData
class Points: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let material: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, material: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.material = material
        self.coordinate = coordinate
        
        super.init()
    }
    init?(data: RecyclingSpot) {
        // 1
        self.title = data.name
        self.locationName = data.spot_id!
        self.material = data.material_id!
        // 2
        self.coordinate = CLLocationCoordinate2D(latitude: Double(data.lat), longitude: Double(data.lng))
        
    }
    var subtitle: String? {
        return locationName
    }
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}

