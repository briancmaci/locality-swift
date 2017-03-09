//
//  FirebaseManager.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/1/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Firebase

class FirebaseManager: NSObject {
    
    class func initFirebase() {
        FIRApp.configure()
    }
    
    class func authenticateFacebook() {
    }
    
    class func loadCurrentUserModel(completionHandler: @escaping (Bool?, Error?) -> ()) -> () {
        
        FirebaseManager.getCurrentUserRef().observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists() {
                let userDic = snapshot.value as? NSDictionary
                CurrentUser.shared.username = userDic?[K.DB.Var.Username] as! String
                CurrentUser.shared.isFirstVisit = userDic?[K.DB.Var.IsFirstVisit] as! Bool
                CurrentUser.shared.profileImageUrl = userDic?[K.DB.Var.ProfileImageURL] as! String
                CurrentUser.shared.currentLocation = FeedLocation(firebaseDictionary:userDic?[K.DB.Var.CurrentLocation] as! [String : AnyObject])
                print("Login:username? \(CurrentUser.shared.username)")
                print("Login:IsFirstTime? \(CurrentUser.shared.isFirstVisit )")
                print("Login:CurrentLocation? \(CurrentUser.shared.currentLocation)")
                
                completionHandler(true, nil)
            }
        })
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
    
    
}
