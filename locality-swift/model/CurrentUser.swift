//
//  CurrentUser.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/2/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseAuth

class CurrentUser: NSObject {

    static let shared = CurrentUser()
    
    var uid:String = ""
    var email:String = ""
    
    var username:String = ""
    var profileImageUrl:String = K.Image.DefaultAvatarProfile
    var isFirstVisit:Bool = true
    var status:UserStatusType = .newUser
    
    var currentLocation:FeedLocation!
    var pinnedLocations:[FeedLocation]!
    
    func extraAttributesToFirebase() -> [String:Any] {
        
        return [K.DB.Var.IsFirstVisit : isFirstVisit,
                K.DB.Var.Status : status.rawValue,
                K.DB.Var.Username : username,
                K.DB.Var.ProfileImageURL : profileImageUrl]
    }
    

}
