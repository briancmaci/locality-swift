//
//  SortBy.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

enum SortByType:Int {
    case proximity = 0, time, activity
}

class SortBy: NSObject {
    
    class func getIcon(type:SortByType) -> String {
        switch type {
        case .proximity:
            return K.Icon.Sort.Proximity
            
        case .time:
            return K.Icon.Sort.Time
            
        case .activity:
            return K.Icon.Sort.Activity
        }
    }
}
