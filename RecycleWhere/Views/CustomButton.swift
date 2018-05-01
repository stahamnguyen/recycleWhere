//
//  CustomButton.swift
//  RecycleWhere
//
//  Created by Staham Nguyen on 01/05/2018.
//  Copyright © 2018 RecycleWhere. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    var size: CGSize?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(size: CGSize, title: String, tintColor: UIColor, fontSize: CGFloat) {
        self.init(type: .system)
        self.size = size
        self.setTitle(title, for: .normal)
        self.tintColor = tintColor
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
