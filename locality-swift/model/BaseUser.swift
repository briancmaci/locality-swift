//
//  BaseUser.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseDatabase

class BaseUser: NSObject {

    var uid:String = ""
    var username:String = ""
    var profileImageUrl:String = K.Image.DefaultAvatarProfile
    var status:UserStatusType = .newUser
    
    convenience init(uid:String, username:String, imgUrl:String, status:UserStatusType) {
        
        self.init()
        self.uid = uid
        self.username = username
        self.status = status
        self.profileImageUrl = imgUrl
    }
    
    convenience init(snapshot: FIRDataSnapshot) {
        self.init()
        let dic = snapshot.value as? [String:Any]
        
        self.uid = dic?[K.DB.Var.UserId] as! String
        self.username = dic?[K.DB.Var.Username] as! String
        self.status = UserStatusType(rawValue:(dic?[K.DB.Var.Status] as! Int))!
        self.profileImageUrl = dic?[K.DB.Var.ProfileImageURL] as! String
    }
}
