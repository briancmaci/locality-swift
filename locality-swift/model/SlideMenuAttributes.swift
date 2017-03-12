//
//  SlideMenuAttributes.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/11/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class SlideMenuAttributes: NSObject {
    
    
    enum MenuActionType:Int {
        case segue = 0, action, unknown
    }

    enum MenuStyleType:Int {
        case light = 0, dark
    }
    
    class func actionFromString(action:String) -> MenuActionType {
        
        if action == K.String.Menu.Action.Segue {
            return .segue
        }
        
        else if action == K.String.Menu.Action.Action {
            return .action
        }
        
        else {
            return .unknown
        }
    }
    
    class func styleFromString(style:String) -> MenuStyleType {
        
        if style == K.String.Menu.Style.Light {
            return .light
        }
        
        else {
            return .dark
        }
    }
}
