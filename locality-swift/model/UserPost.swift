//
//  UserPost.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Mapbox

class UserPost: NSObject {

    var user:BaseUser = BaseUser()
    
    var createdDate:Date = Date()
    var postId:String = ""
    var userHandle:String = ""
    var lat:Double = 0.0
    var lon:Double = 0.0
    var caption:String = ""
    var postImageUrl:String = ""
    
    var commentsCount:Int = 0
    var likedBy:[String] = [String]()
    
    var isLikedByMe:Bool = false
    
    init(coord:CLLocationCoordinate2D, caption:String, imgUrl:String, user:BaseUser) {
        
        //This may change once we pull other users' posts
        
        self.createdDate = Date()
        self.postId = Util.generateUUID()
        self.userHandle = user.uid
        
        self.lat = coord.latitude
        self.lon = coord.longitude
        self.caption = caption
        self.postImageUrl = imgUrl
        
        self.user = user
    }
    
    init(snapshot: FIRDataSnapshot) {
        super.init()
        let dic = snapshot.value as? [String:Any]
        
        let dateString = dic?[K.DB.Var.CreatedDate] as! String
        
        self.createdDate = Util.dateFromString(dateStr: dateString)
        self.postId = dic?[K.DB.Var.PostId] as! String
        
        self.lat = dic?[K.DB.Var.Lat] as! Double
        self.lon = dic?[K.DB.Var.Lon] as! Double
        self.caption = dic?[K.DB.Var.Caption] as! String
        
        if (dic?[K.DB.Var.LikedBy]) != nil {
            self.likedBy = dic?[K.DB.Var.LikedBy] as! [String]
        }
            self.postImageUrl = dic?[K.DB.Var.PostImageURL] as! String
        self.userHandle = dic?[K.DB.Var.UserId] as! String
        self.user = BaseUser()
        
        //Set is likedByMe
        self.isLikedByMe = self.likedBy.contains(CurrentUser.shared.uid)
    }


    func toFirebaseObject() -> [String:Any] {
        return[K.DB.Var.CreatedDate:Util.stringFromDate(date: createdDate),
               K.DB.Var.PostId:postId,
               K.DB.Var.UserId:userHandle,
               K.DB.Var.Lat:lat,
               K.DB.Var.Lon:lon,
               K.DB.Var.Caption:caption,
               K.DB.Var.PostImageURL:postImageUrl,
               K.DB.Var.LikedBy:likedBy]
    }
}
