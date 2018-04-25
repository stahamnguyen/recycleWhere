//
//  ViewController.swift
//  RecycleWhere
//
//  Created by Staham Nguyen on 18/04/2018.
//  Copyright © 2018 Staham Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let materialService = MaterialService()
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        materialService.getCategories()
        
        guard let categories = userDefaults.object(forKey: "materials") as? [String] else {
            fatalError("Type cast error fetching categories from user defaults")
        }
        
        print(categories)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

