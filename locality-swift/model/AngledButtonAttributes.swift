//
//  AngledButtonAttributes.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/1/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class AngledButtonAttributes: NSObject {
    
    var backgroundColor : UIColor = .white
    var titleColor : UIColor = .black
    var title : String = ""
    var fontSize : CGFloat = 16
    var fontName : String = K.FontName.InterstateLightCondensed
    
    init( title:String, titleColor:UIColor, backgroundColor:UIColor) {
        
        self.title = title
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
    }

}
