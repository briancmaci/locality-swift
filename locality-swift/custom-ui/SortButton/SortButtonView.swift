//
//  SortButtonView.swift
//  PopupMenu
//
//  Created by Chelsea Power on 3/18/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class SortButtonView: UIView {
    
    @IBOutlet weak var bg:UIImageView!
    @IBOutlet weak var icon:UIImageView!
    
    func updateIcon(type:SortByType) {
        
        icon.image = UIImage(named:SortBy.getIcon(type: type))
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
