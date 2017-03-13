//
//  CurrentUser.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/2/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseAuth

class CurrentUser: BaseUser {

    static let shared = CurrentUser()
    
    var isMetric:Bool = false
    
    var email:String = ""
    var isFirstVisit:Bool = true
    
    var currentLocation:FeedLocation!
    var pinnedLocations:[FeedLocation] = [FeedLocation]()
    
    func extraAttributesToFirebase() -> [String:Any] {
        
        return [K.DB.Var.IsFirstVisit : isFirstVisit,
                K.DB.Var.Status : status.rawValue,
                K.DB.Var.Username : username,
                K.DB.Var.ProfileImageURL : profileImageUrl]
    }
    

}
