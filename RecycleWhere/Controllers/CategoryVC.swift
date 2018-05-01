//
//  CategoryVC.swift
//  RecycleWhere
//
//  Created by Staham Nguyen on 01/05/2018.
//  Copyright © 2018 RecycleWhere. All rights reserved.
//

import UIKit
import Foundation

class CategoryVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var imageView = UIImageView()
    var categoryPickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        createBackground()
        setupImageView()
        setupPickerView()
    }
    
    // MARK: UI methods
    
    func createBackground() {
        let bg = RadialGradientView()
        bg.insideColor = LIGHT_BLUE
        bg.outsideColor = DARK_BLUE
        bg.frame = UIScreen.main.bounds
        
        view.addSubview(bg)
    }
    
    func setupImageView() {
        self.imageView.frame = CGRect(x: SCREEN_WIDTH / 2 - 150, y: SCREEN_HEIGHT / 2 - 300, width: 300, height: 300)
        self.imageView.contentMode = .scaleAspectFit
        
        view.addSubview(self.imageView)
    }
    
    func setupPickerView() {
        self.categoryPickerView.frame.size = CGSize(width: SCREEN_WIDTH - 40, height: SCREEN_HEIGHT / 2 - 70)
        
        view.addSubview(categoryPickerView)
        
        self.categoryPickerView.translatesAutoresizingMaskIntoConstraints = false;
        let views = ["pickerView": self.categoryPickerView, "imageView": self.imageView]
        self.categoryPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[imageView]-(50)-[pickerView]-(70)-|", options: .alignAllCenterX, metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalConstraint)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 9 // Put fetched data here
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = "Test" // Put fetched data here
        
        let styledTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font: UIFont(name: "Georgia", size: 15.0)!, NSAttributedStringKey.foregroundColor: WHITE])
        return styledTitle
    }
}
