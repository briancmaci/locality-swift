//
//  PopupButtonView.swift
//  PopupMenu
//
//  Created by Chelsea Power on 3/17/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

let kPointHeight:CGFloat = 8.0
let kPopButtonWidth:CGFloat = 46.0
let kButtonHeight:CGFloat = kPopButtonWidth + kPointHeight
let kImageWidth:CGFloat = 22.0
let kImageHeight:CGFloat = 22.0

class PopupButtonView: UIView {
    
    
    
    var bg:UIView!
    var icon:UIImageView!
    var type:SortByType!
    
    //for instant switching
    var iconOffImage:UIImage!
    var iconOnImage:UIImage!
    
    convenience init(type:SortByType) {
        self.init(frame:CGRect.zero)
        
        self.type = type
        self.frame = CGRect(origin:CGPoint.zero, size:CGSize(width: kPopButtonWidth, height: kButtonHeight))
        
        self.bg = UIView(frame: self.frame)
        self.addSubview(self.bg)
        
        let img = UIImage(named: SortBy.getIcon(type:type))
        self.icon = UIImageView(frame: CGRect(origin:CGPoint.zero, size:CGSize(width:kImageWidth, height:kImageHeight)))
        
        self.icon.image = img
        
        iconOffImage = img?.maskWithColor(color: K.Color.sortIconOff)
        iconOnImage = img?.maskWithColor(color: K.Color.sortIconOn)
        
        var iconFrame:CGRect = self.icon.frame
        
        iconFrame.origin.x = (frame.size.width - self.icon.frame.size.width)/2
        iconFrame.origin.y = (frame.size.height - self.icon.frame.size.height)/2 - kPointHeight/2
        
        self.icon.frame = iconFrame
        
        addSubview(self.icon)
        
        updateStage(on:false)
        
        isUserInteractionEnabled = false
    }
    
    func updateStage(on:Bool) {
        bg.backgroundColor = (on == true) ? K.Color.sortBackgroundOn : K.Color.sortBackgroundOff
        
        if on == true {
            icon.image = iconOnImage
        }
        
        else {
            icon.image = iconOffImage
        }
    }
}
