//
//  HeaderIconButton.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/8/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class HeaderIconButton: UIButton {

    var iconType:HeaderIconType!
    
    init(type:HeaderIconType) {
        super.init(frame:CGRect.zero)
        
        iconType = type
        
        let img = UIImage(named: HeaderIcon.imageName(type:iconType))
        
        setImage(img, for: .normal)
        frame = CGRect(x:0,
                       y:0,
                       width:img!.size.width + K.NumberConstant.Header.ButtonPadding,
                       height:img!.size.height + K.NumberConstant.Header.ButtonPadding)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateIconType(type:HeaderIconType) {
        iconType = type
        setImage(UIImage(named:HeaderIcon.imageName(type:iconType)), for: .normal)
    }
}
