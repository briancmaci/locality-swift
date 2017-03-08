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
    
    class func loadCurrentUserModel() {
        FirebaseManager.getCurrentUserRef().observeSingleEvent(of: .value, with: { (snapshot) in
            
            let userDic = snapshot.value as? NSDictionary
            CurrentUser.shared.username = userDic?[K.DB.Var.Username] as! String
            CurrentUser.shared.isFirstVisit = userDic?[K.DB.Var.IsFirstVisit] as! Bool
            CurrentUser.shared.profileImageUrl = userDic?[K.DB.Var.ProfileImageURL] as! String
            
            print("Login:username? \(CurrentUser.shared.username)")
            print("Login:IsFirstTime? \(CurrentUser.shared.isFirstVisit )")
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
