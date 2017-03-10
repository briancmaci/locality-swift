//
//  PostFromViewToggle.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class PostFromViewToggle: UIView {

    @IBOutlet weak var label:UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var check:UIImageView!
    
    var initialImage:UIImage!
    var isSelected:Bool!
    var imageIsMultiplied:Bool = false
    
    func setSelected(yes:Bool) {
        backgroundColor = yes ? K.Color.toggleRed : K.Color.toggleGray
        label.textColor = yes ? .white : K.Color.localityBlue
        check.isHidden = !yes
        
        if imageIsMultiplied == true {
            img.image = initialImage.tinted(color:backgroundColor!)
        }
        
        isSelected = yes
    }
    
    func setForMultiply() {
        imageIsMultiplied = true
        initialImage = img.image
    }
}
