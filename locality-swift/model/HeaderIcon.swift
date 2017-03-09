//
//  HeaderIcon.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/8/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

enum HeaderIconType:Int {
    case back = 0, close, hamburger, settings, feedMenu, none
}

class HeaderIcon: NSObject {

    class func imageName(type:HeaderIconType) -> String {
    
        switch (type) {
            case .back:
            return K.Icon.Header.Back
            
            case .close:
            return K.Icon.Header.Close
            
            case .hamburger:
            return K.Icon.Header.Hamburger
            
            case .settings:
            return K.Icon.Header.Settings
            
            case .feedMenu:
            return K.Icon.Header.FeedMenu
            
            case .none:
            return ""
        }
    }

}
