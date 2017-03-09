//
//  UserPost.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Mapbox

class UserPost: NSObject {

    var user:BaseUser
    
    var createdDate:Date
    var postId:String
    var lat:Double
    var lon:Double
    var caption:String
    var postImageUrl:String = ""
    
    var commentsCount:Int = 0
    var likesCount:Int = 0
    
    var isLikedByMe:Bool = false
    
    init(coord:CLLocationCoordinate2D, caption:String, imgUrl:String) {
        
        //This may change once we pull other users' posts
        
        self.createdDate = Date()
        self.postId = Util.generateUUID()
        
        self.lat = coord.latitude
        self.lon = coord.longitude
        self.caption = caption
        self.postImageUrl = imgUrl
        
        user = CurrentUser.shared as BaseUser
    }
}
