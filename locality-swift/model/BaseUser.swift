//
//  BaseUser.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

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
}
