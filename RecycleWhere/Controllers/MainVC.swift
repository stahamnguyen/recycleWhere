//
//  ViewController.swift
//  RecycleWhere
//
//  Created by Staham Nguyen on 18/04/2018.
//  Copyright © 2018 Staham Nguyen & Erkki Halinen. All rights reserved.
//

import UIKit

class MainVC: UIViewController, XMLParserDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var logo: UIImageView?
    var button: CustomButton?
    
    let imagePicker = UIImagePickerController()

    let materialService = MaterialService()
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        createBackground()
        createLogo()
        createButton()
        addHandlerForButton()
        
        materialService.getCategories()
        
        guard let categories = userDefaults.object(forKey: "materials") as? [String] else {
            print("Type cast error fetching categories from user defaults")
            return
        }
        print(categories)
        
        self.parseServerXmlResponse()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: UI methods
    
    func createBackground() {
        let bg = RadialGradientView()
        bg.insideColor = LIGHT_BLUE
        bg.outsideColor = DARK_BLUE
        bg.frame = UIScreen.main.bounds
        
        view.addSubview(bg)
    }
    
    func createLogo() {
        self.logo = UIImageView(image: UIImage(named: "logo"))
        self.logo?.contentMode = .scaleAspectFit
        self.logo?.frame = CGRect(x: SCREEN_WIDTH / 2 - 100, y: SCREEN_HEIGHT / 2 - 200, width: 200, height: 200)
        
        view.addSubview(self.logo!)
    }
    
    func createButton() {
        self.button = CustomButton(size: CGSize(width: 200, height: 50), title: "Press to Identify", tintColor: WHITE, fontSize: 30)
        view.addSubview(self.button!)
        
        self.button?.translatesAutoresizingMaskIntoConstraints = false;
        let views = ["logo": self.logo!, "button": self.button!]
        self.button?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[logo]-(50)-[button]", options: .alignAllCenterX, metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalConstraint)
    }
    
    // MARK: Add handler for button
    
    func addHandlerForButton() {
        self.button?.addTarget(self, action: #selector(self.chooseImage), for: .touchUpInside)
    }
    
    @objc func chooseImage() {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take a photo",
                                            style: .default,
                                            handler: { action in self.takePhoto()}))
        actionSheet.addAction(UIAlertAction(title: "Choose from library",
                                            style: .default,
                                            handler: { action in self.choosePhotoFromLibrary()}))
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: ImagePicker
    
    func choosePhotoFromLibrary() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            dismiss(animated: true, completion: {
                self.navigateToCategoryVC(with: chosenImage)
            })
        }
    }
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker, animated: true, completion: nil)
        } else {
            alertThatThereIsNoCamera()
        }
    }
    
    func alertThatThereIsNoCamera() {
        let alertVC = UIAlertController(
            title: "No camera detected",
            message: "There is no camera on your device.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    // MARK: Navigate to Category VC
    
    func navigateToCategoryVC(with chosenImage: UIImage) {
        let categoryVC = CategoryVC()
        categoryVC.imageView = UIImageView(image: chosenImage)
        navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    // MARK: Reveal navigation bar for next VC if needed
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        // Make the navigation bar translucent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
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

