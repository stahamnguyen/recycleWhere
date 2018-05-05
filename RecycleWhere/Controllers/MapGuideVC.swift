//
//  MapGuideVC.swift
//  RecycleWhere
//
//  Created by Staham Nguyen on 02/05/2018.
//  Copyright © 2018 RecycleWhere. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapGuideVC: UIViewController, XMLParserDelegate, NSFetchedResultsControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let mapView = MKMapView()
    var controller = NSFetchedResultsController<RecyclingSpot>()
    var previousViewController: UIViewController?
    var initlocation: CLLocation?
    let locationManager = CLLocationManager()
    var recpoints: [Points] = []
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backShadow")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backShadow")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //Call RecyclingSpotService here maybe ?
        //After that utilize the xml parsing functions with the Data received from API
        
        setupMapView()
        
        let recyclingSpots = RecyclingSpotService()
        
        let dataFromApi = recyclingSpots.fetchRecyclingSpots(60.2208903, 24.8027918)
        
        parseServerXmlResponse(apiData: dataFromApi)
        
        fetchRecyclingSpotFromCoreData()
        
        initlocation = CLLocation(latitude: 60.2208903, longitude: 24.8027918)
        
        centerMapOnLocation(location: initlocation!)
        
        mapView.addAnnotations(recpoints)
    }
    
    func setupMapView() {
        view.addSubview(self.mapView)
        
        self.mapView.translatesAutoresizingMaskIntoConstraints = false;
        let views = ["mapView": self.mapView]
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[mapView]-(0)-|", options: .alignAllCenterX, metrics: nil, views: views)
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[mapView]-(0)-|", options: .alignAllCenterX, metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalConstraint)
        NSLayoutConstraint.activate(horizontalConstraint)
    }
    //
    //fetch recycling spot
    func fetchRecyclingSpotFromCoreData() {
        let fetchRequest: NSFetchRequest<RecyclingSpot> = RecyclingSpot.fetchRequest()
        let descriptor = NSSortDescriptor(key:"name", ascending: true)
        fetchRequest.sortDescriptors = [descriptor]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller
        self.controller.delegate = self
        do {
            try self.controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        let data = self.controller.fetchedObjects
        for miniData in data! {
            recpoints.append(Points(data: miniData)!)
        }
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    let regionRadius: CLLocationDistance = 5000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - XML parsing methods
    
    /*
     //########################  TEST IMPLEMENTATION WITH URL, ACTUAL IMPLEMENTATION BELOW
     func parseServerXmlResponse() {
     let url: URL = URL(string: "http://kierratys.info/1.5/genxml.php?lat=60.2222&lng=25.08888")!
     let parser = XMLParser(contentsOf: url)!
     parser.delegate = self
     //Initiates parsing of the data
     parser.parse()
     }
     #############################
     */
    
    //Parsing function requires Data object from the RecyclingSpotService function
    func parseServerXmlResponse(apiData: Data) {
        let parser = XMLParser(data: apiData)
        parser.delegate = self
        //Initiates parsing of the data
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("Starting " + elementName)
        
        if(elementName == "marker") {
            self.createRecyclingSpot(attributeDict)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("Ending " + elementName)
        
        if(elementName == "markers") {
            //Save context when all of the recycling spots have been read
            try? AppDelegate.viewContext.save()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Parse error " + parseError.localizedDescription)
    }
    
    //Creates a new recycling spot, given the list of attributes required for it
    private func createRecyclingSpot(_ attributeDict: [String: String]) {
        
        let recyclingSpot = RecyclingSpot(context: AppDelegate.viewContext)
        
        for attribute in attributeDict {
            
            switch attribute.key {
                
            case "paikka_id" :
                recyclingSpot.spot_id = attribute.value
                break
            case "lat" :
                recyclingSpot.lat = Float(attribute.value)!
                break
            case "lng" :
                recyclingSpot.lng = Float(attribute.value)!
                break
            case "nimi" :
                recyclingSpot.name = attribute.value
                break
            case "laji_id" :
                recyclingSpot.material_id = attribute.value
                break
            case "aukiolo" :
                recyclingSpot.openingHours = attribute.value
                break
            case "yhteys" :
                recyclingSpot.contactInfo = attribute.value
                break
                
            default:
                print("Unnecessary attribute " + attribute.key)
            }
        }
    }
}
extension MapGuideVC {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Points else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Points
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}


