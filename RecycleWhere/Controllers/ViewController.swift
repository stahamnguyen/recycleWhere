//
//  ViewController.swift
//  RecycleWhere
//
//  Created by Staham Nguyen on 18/04/2018.
//  Copyright © 2018 Staham Nguyen & Erkki Halinen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate {

    let materialService = MaterialService()
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        materialService.getCategories()
        
        guard let categories = userDefaults.object(forKey: "materials") as? [String] else {
            fatalError("Type cast error fetching categories from user defaults")
        }
        
        print(categories)
        
        self.parseServerXmlResponse()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: XML Parsing methods
    
    //TEST IMPLEMENTATION WITH URL
    func parseServerXmlResponse() {
        let url: URL = URL(string: "http://kierratys.info/1.5/genxml.php?lat=60.2222&lng=25.08888")!
        let parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        //Initiates parsing of the data
        parser.parse()
    }
    
    /* ACTUAL IMPLEMENTATION WITH DATA FROM SERVICE CLASS
    func parseServerXmlResponse(apiData: Data) {
        let parser = XMLParser(data: apiData)
        parser.delegate = self
        //Initiates parsing of the data
        parser.parse()
    }*/
    
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

    // MARK: Private methods
    
    //Creates a new recycling spot, given the list of attributes required for it.
    private func createRecyclingSpot(_ attributeDict: [String: String]) {
        
        let recyclingSpot = RecyclingSpot(context: AppDelegate.viewContext)
        
        for attribute in attributeDict {
            
            switch attribute.key {
                
            case "paikka_id" :
                recyclingSpot.spot_id = attribute.value
                break
            case "lat" :
                recyclingSpot.lat = attribute.value
                break
            case "lng" :
                recyclingSpot.lng = attribute.value
                break
            case "nimi" :
                recyclingSpot.name = attribute.value
                break
            case "laji_id" :
                recyclingSpot.material_id = attribute.value
                break
                
            default:
                print("Unnecessary attribute " + attribute.key)
            }
        }
    }

}

