//
//  RoundedRectangleButton.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/1/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class RoundedRectangleButton: UIButton {
    
    func setAttributes(title:String, titleColor:UIColor, backgroundColor:UIColor) {
        
        //Fix background
        layer.cornerRadius = K.NumberConstant.RoundedButtonCornerRadius
        clipsToBounds = true
        
        setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleColor, for:.normal)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
