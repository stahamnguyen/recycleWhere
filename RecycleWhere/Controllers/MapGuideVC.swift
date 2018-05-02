//
//  MapGuideVC.swift
//  RecycleWhere
//
//  Created by Staham Nguyen on 02/05/2018.
//  Copyright © 2018 RecycleWhere. All rights reserved.
//

import UIKit
import MapKit

class MapGuideVC: UIViewController {
    
    let mapView = MKMapView()
    
    var previousViewController: UIViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backShadow")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backShadow")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
