//
//  FirebaseManager.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/1/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Mapbox

class FirebaseManager: NSObject {
    
    class func initFirebase() {
        FIRApp.configure()
    }
    
    class func loadCurrentUserModel(completionHandler: @escaping (Bool?, Error?) -> ()) -> () {
        
        FirebaseManager.getCurrentUserRef().observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists() {
                let userDic = snapshot.value as? NSDictionary
                CurrentUser.shared.uid = (FIRAuth.auth()?.currentUser?.uid)!
                CurrentUser.shared.email = (FIRAuth.auth()?.currentUser?.email)!
                CurrentUser.shared.username = userDic?[K.DB.Var.Username] as! String
                CurrentUser.shared.isFirstVisit = userDic?[K.DB.Var.IsFirstVisit] as! Bool
                CurrentUser.shared.profileImageUrl = userDic?[K.DB.Var.ProfileImageURL] as! String
                CurrentUser.shared.status = UserStatusType(rawValue:userDic?[K.DB.Var.Status] as! Int)!
                
                
                if let currentLocation = userDic?[K.DB.Var.CurrentLocation] {
                    CurrentUser.shared.currentLocation = FeedLocation(firebaseDictionary:currentLocation as! [String : AnyObject])
                }
                
                if let pinned = userDic?[K.DB.Var.Pinned] as? [[String : AnyObject]]{
                    
                    var pins:[FeedLocation] = [FeedLocation]()
                    
                    for pin in pinned {
                        let l:FeedLocation = FeedLocation(firebaseDictionary:pin)
                        pins.append(l)
                    }
                    
                    CurrentUser.shared.pinnedLocations = pins
                }
                
                completionHandler(true, nil)
            }
        })
    }
    
    class func loadFeedPosts(postIDs:[String], completionHandler: @escaping ([UserPost]?, Error?) -> ()) -> () {
        
        var posts:[UserPost] = [UserPost]()
        
        getPostsRef().observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let childSnap = child as! FIRDataSnapshot
                if postIDs.contains(childSnap.key) {
                    posts.append(UserPost(snapshot: childSnap))
                }
            }
            
            completionHandler(posts, nil)
        })
    }
    
    class func getPostBaseUser(uid:String, completionHandler: @escaping (BaseUser?) -> ()) -> () {
        
        var thisUser:BaseUser!
        
        getUsersRef().child(uid).observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                completionHandler(nil)
                return
            }
            
            let userDic = snapshot.value as? [String:Any]
            
            thisUser = BaseUser(uid: uid,
                                username: userDic?[K.DB.Var.Username] as! String,
                                imgUrl: userDic?[K.DB.Var.ProfileImageURL] as! String,
                                status: UserStatusType(rawValue:userDic?[K.DB.Var.Status] as! Int)!)
            
            completionHandler(thisUser)
        })
    }
    
    class func write(post:UserPost, completionHandler: @escaping (Bool?, Error?) -> ()) -> () {
        
        FirebaseManager.getPostsRef().child(post.postId).updateChildValues(post.toFirebaseObject()) { (error, ref) in
            if error != nil {
                completionHandler(false, error)
            }
            
            else {
                completionHandler(true, nil)
            }
        }
    }
    
    class func write(pinnedLocations:[FeedLocation], completionHandler: @escaping (Bool?, Error?) -> ()) -> () {
        
        //add location to pinned locations
        var firPinnedArray:[[String:Any]] = [[String:Any]]()
        
        for loc in pinnedLocations {
            firPinnedArray.append(loc.toFireBaseObject())
        }
        
        FirebaseManager.getCurrentUserRef().child(K.DB.Var.Pinned).setValue(firPinnedArray) { (error, ref) in
            if error != nil {
                completionHandler(false, error)
            }
                
            else {
                completionHandler(true, nil)
            }
        }
    }
    
    class func getUsersRef() -> FIRDatabaseReference {
        return FIRDatabase.database().reference(withPath:K.DB.Table.Users)
    }
    
    class func getCurrentUserRef() -> FIRDatabaseReference {
        return getUsersRef().child(getCurrentUser().uid)
    }
    
    class func getCurrentUser() -> FIRUser {
        return (FIRAuth.auth()?.currentUser)!
    }
    
    class func getPostsRef() -> FIRDatabaseReference {
        return FIRDatabase.database().reference(withPath:K.DB.Table.Posts)
    }
    
    class func getStorageRef() -> FIRStorageReference {
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        
        return storageRef
    }
    
    class func getImageStorageRef() -> FIRStorageReference {
        return getStorageRef().child(K.DB.Storage.Images)
    }
    
}
