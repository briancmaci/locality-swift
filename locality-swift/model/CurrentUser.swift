//
//  CurrentUser.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/2/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseAuth
import Mapbox

class CurrentUser: BaseUser {

    static let shared = CurrentUser()
    
    var isMetric:Bool = false
    
    var email = ""
    var password = "" //This is only used for email verification
    var facebookToken = "" //This is only used for email verification
    
    var isFirstVisit = true
    
    var currentLocationFeed: FeedLocation!
    var pinnedLocations: [FeedLocation] = [FeedLocation]()
    
    //sort
    var sortByType: SortByType = .proximity
    
    //feed location
    var myLastRecordedLocation: CLLocationCoordinate2D! = nil
    
    //update rate
    var updateInterval: TimeInterval = 30
    
    func extraAttributesToFirebase() -> [String:Any] {
        
        return [K.DB.Var.IsFirstVisit : isFirstVisit,
                K.DB.Var.Status : status.rawValue,
                K.DB.Var.Username : username,
                K.DB.Var.ProfileImageURL : profileImageUrl]
    }
    

}
