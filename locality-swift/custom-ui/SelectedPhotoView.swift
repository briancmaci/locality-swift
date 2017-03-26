//
//  SelectedPhotoView.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/20/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

protocol SelectedPhotoDelegate {
    func photoHasBeenRemoved()
}

class SelectedPhotoView: UIView {

    @IBOutlet weak var imgView:UIImageView!
    @IBAction func closeButtonDidTouch(sender:UIButton) {
        set(hidden:true)
        
        delegate?.photoHasBeenRemoved()
    }
    
    var delegate:SelectedPhotoDelegate?
    
    func populateImage(img:UIImage) {
        imgView.image = img
        set(hidden:false)
    }
    
    func set(hidden:Bool) {
        
        if hidden == false {
            self.isHidden = false
            UIView.animate(withDuration: 0.2, animations: { 
                self.alpha = 1
            }, completion: { (success) in
                self.imgView.isUserInteractionEnabled = true
            })
        }
        
        else {
            UIView.animate(withDuration: 0.2, animations: { 
                self.alpha = 0
            }, completion: { (success) in
                self.imgView.image = nil
                self.isHidden = true
                
                self.imgView.isUserInteractionEnabled = false
            })
        }
    }
    
}
