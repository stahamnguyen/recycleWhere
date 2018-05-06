import Foundation
import MapKit
import Contacts
import CoreData
class Points: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let aukiolo: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, aukiolo: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.aukiolo = aukiolo
        self.coordinate = coordinate
        
        super.init()
    }
    init?(data: RecyclingSpot) {
        // 1
        self.title = data.name
        self.locationName = data.openingHours!
        self.aukiolo = data.openingHours!
        // 2
        self.coordinate = CLLocationCoordinate2D(latitude: Double(data.lat as String!)!, longitude: Double(data.lng as String!)!)
        
    }
    var subtitle: String? {
        return locationName
    }
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        print("draw map item")
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}

