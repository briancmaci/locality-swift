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
    
    class func loadFeedPosts(postIDs:[String],
                             orderedBy:SortByType,
                             completionHandler: @escaping ([UserPost]?, Error?) -> ()) -> () {
        
        var posts:[UserPost] = [UserPost]()
        var postsDic:[UserPost:Double] = [UserPost:Double]()
        
        switch orderedBy {
        case .proximity:
        
            getPostsRef().observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let childSnap = child as! FIRDataSnapshot
                    if postIDs.contains(childSnap.key) {
                        //posts.append(UserPost(snapshot: childSnap))
                        
                        //push to dictionary before sorting
                        let p = UserPost(snapshot: childSnap)
                        postsDic[p] = Util.distanceFrom(lat: p.lat, lon: p.lon)
                        
                    }
                }
                
                //let's order the dictionary by key(distance)
                let sortedKeys = Array(postsDic).sorted(by: {$0.1 < $1.1})

                for p in sortedKeys {
                    posts.append(p.key)
                }
                
                completionHandler(posts, nil)
            })
            
        case .time:
            getPostsRef().queryOrdered(byChild: K.DB.Var.CreatedDate).observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let childSnap = child as! FIRDataSnapshot
                    if postIDs.contains(childSnap.key) {
                        posts.append(UserPost(snapshot: childSnap))
                    }
                }
                
                //We have to reverse these to make the newest 
                completionHandler(posts.reversed(), nil)
            })
            
        case .activity:
            getPostsRef().queryOrdered(byChild: K.DB.Var.CommentCount).observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let childSnap = child as! FIRDataSnapshot
                    if postIDs.contains(childSnap.key) {
                        posts.append(UserPost(snapshot: childSnap))
                    }
                }
                
                completionHandler(posts.reversed(), nil)
            })
                
        }
        
        
    }
    
    class func loadFeedComments(postId:String, completionHandler: @escaping ([UserComment]?, Error?) -> ()) -> () {
        
        var comments:[UserComment] = [UserComment]()
        
        getCommentsRef().queryOrdered(byChild: K.DB.Var.PostId).queryEqual(toValue: postId).observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
                comments.append(UserComment(snapshot: child as! FIRDataSnapshot))
            }
            
            //sort comments by date
            let commentsSorted:[UserComment] = comments.sorted(by: { $0.createdDate < $1.createdDate })
            
            completionHandler(commentsSorted, nil)
        })
    }
    
    class func getTotalLikes(completionHandler: @escaping (Int?) -> ()) -> () {
        var likes:Int = 0
        getPostsRef().queryOrdered(byChild:K.DB.Var.UserId).queryEqual(toValue: CurrentUser.shared.uid).observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists() {
                for child in snapshot.children {
            
                let childDic = (child as! FIRDataSnapshot).value as? NSDictionary
                    if let likesArray = childDic?.object(forKey:K.DB.Var.LikedBy) as? NSArray {
                        likes += likesArray.count
                    }}
                
                completionHandler(likes)
            }
            
            else {
                completionHandler(nil)
            }
        })
    }
    
    class func getTotalPosts(completionHandler: @escaping (Int?) -> ()) -> () {
        var posts:Int = 0
        
        getPostsRef().queryOrdered(byChild:K.DB.Var.UserId).queryEqual(toValue: CurrentUser.shared.uid).observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists() {
                posts = snapshot.children.allObjects.count
                completionHandler(posts)
            }
                
            else {
                completionHandler(nil)
            }
        })
    }
    
    class func getUserFromHandle(uid:String, completionHandler: @escaping (BaseUser?) -> ()) -> () {
        
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
        
        getPostsRef().child(post.postId).updateChildValues(post.toFirebaseObject()) { (error, ref) in
            if error != nil {
                completionHandler(false, error)
            }
            
            else {
                completionHandler(true, nil)
            }
        }
    }
    
    class func write(comment:UserComment, completionHandler: @escaping (Bool?, Error?) -> ()) -> () {
        
        getCommentsRef().child(comment.commentId).updateChildValues(comment.toFirebaseObject()) { (error, ref) in
            if error != nil {
                completionHandler(false, error)
            }
                
            else {
                
                //Increment post count
                let countRef = getPostsRef().child(comment.postId).child(K.DB.Var.CommentCount)
                countRef.runTransactionBlock({ (countData) -> FIRTransactionResult in
                    
                    var value:NSNumber!
                    
                    if countData.value is NSNull {
                        value = 0
                    }
                    else {
                        value = countData.value as! NSNumber
                    }
                    
                    countData.value = NSNumber(integerLiteral: (1 + value.intValue))
                    return FIRTransactionResult.success(withValue: countData)
                    
                }, andCompletionBlock: { (error, success, snapshot) in
                    
                    if success == true {
                        //print("Number incremented!")
                    }
                    
                    completionHandler(true, nil)
                })
                
            }
        }
    }
    
    //Once we've successfully liked we return the likesArray to save to current user
    class func likePost(pid:String, completionHandler: @escaping ([String]?, Error?) -> ()) -> () {
        
        //Grab likes
        getPostsRef().child(pid).child(K.DB.Var.LikedBy).observeSingleEvent(of: .value, with: { snapshot in
            
            var likesArray:[String] = [String]()
            
            if snapshot.exists() {
                //create likedBy
                likesArray = snapshot.value as! [String]
            }
            
            //add us
            
            if !likesArray.contains(CurrentUser.shared.uid) {
                likesArray.append(CurrentUser.shared.uid)
            }
            
            else {
                print("We were already liking this post. Look into this.")
            }
            
            getPostsRef().child(pid).updateChildValues([K.DB.Var.LikedBy:likesArray], withCompletionBlock: { (error, ref) in
                
                if error != nil {
                    completionHandler(nil, error)
                }
                
                else {
                    completionHandler(likesArray, nil)
                }
            })
        })
    }
    
    class func unlikePost(pid:String, completionHandler: @escaping ([String]?, Error?) -> ()) -> () {
        
        //Grab likes
        getPostsRef().child(pid).child(K.DB.Var.LikedBy).observeSingleEvent(of: .value, with: { snapshot in
            
            var likesArray:[String] = [String]()
            
            if snapshot.exists() {
                //create likedBy
                likesArray = snapshot.value as! [String]
            }
            
            //add us
            
            if likesArray.contains(CurrentUser.shared.uid) {
                likesArray.remove(at: likesArray.index(of: CurrentUser.shared.uid)!)
            }
            
            else {
                print("We were not included in LikedBy array for this post. Look into this.")
            }
            
            getPostsRef().child(pid).updateChildValues([K.DB.Var.LikedBy:likesArray], withCompletionBlock: { (error, ref) in
                
                if error != nil {
                    completionHandler(nil, error)
                }
                    
                else {
                    completionHandler(likesArray, nil)
                }
            })
        })
    }
    
    class func delete(post:UserPost, completionHandler: @escaping (Error?) -> ()) -> () {
        
        //Cascade removing image, comments, location, post
        getPostsRef().child(post.postId).removeValue { (error, ref) in
            if error == nil {
                //delete location
                GeoFireManager.delete(postId: post.postId, completionHandler: { (error) in
                    if error == nil {
                        //delete comments
                        print("location deleted")
                        getCommentsRef().queryOrdered(byChild: K.DB.Var.PostId).queryEqual(toValue: post.postId).observeSingleEvent(of: .value, with: { snapshot in
                            for child in snapshot.children {
                                print("CHILD? \(child)")
                                (child as AnyObject).ref.removeValue(completionBlock: { (error, ref) in
                                    print("Comment deleted")
                                })
                            }
                        })
                        
                        //delete photo
                        PhotoUploadManager.deletePhoto(url:post.postImageUrl, completionHandler: { (error) in
                            if error == nil {
                                print("Photo deleted!")
                            }
                        })
                        completionHandler(error)
                    }
                })
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
    
    class func getCommentsRef() -> FIRDatabaseReference {
        return FIRDatabase.database().reference(withPath:K.DB.Table.Comments)
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
