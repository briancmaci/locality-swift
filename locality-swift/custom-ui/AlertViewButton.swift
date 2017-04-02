//
//  AlertViewButton.swift
//  locality-swift
//
//  Created by Chelsea Power on 4/2/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class AlertViewButton: UIButton {
    
    let kTitleFontSize: CGFloat = 14
    
    convenience init(frame: CGRect, title: String) {
        
        self.init(frame: frame)
        
        self.titleLabel?.font = UIFont(name: K.FontName.InterstateLightCondensed, size: kTitleFontSize)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        
        self.backgroundColor = K.Color.localityBlue
        
        //rounded
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }
}
