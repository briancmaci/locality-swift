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
    
//    class func getErrorString(error:Error) -> String{
//        if let errorCode = FIRAuthErrorCode(rawValue: (error._code)){
//            
//            switch errorCode {
//            case .errorCodeInvalidEmail:
//                return K.String.Error.EmailInvalid.localized
//                
//            case .errorCodeEmailAlreadyInUse:
//                return K.String.Error.EmailDuplicate.localized
//                
//            case .errorCodeWeakPassword:
//                return K.String.Error.PasswordTooWeak.localized
//                
//            case .errorCodeUserDisabled:
//                return K.String.Error.UserDisabled.localized
//                
//            case .errorCodeWrongPassword:
//                return K.String.Error.PasswordWrong.localized
//                
//            default:
//                return ""
//            }
//        }
//        
//        else {
//            print("FirebaseManager:Error code not retrieved")
//            return ""
//        }
//    }
    
    
    class func loadCurrentUserModel() {
        FirebaseManager.getCurrentUserRef().observeSingleEvent(of: .value, with: { (snapshot) in
            
            let userDic = snapshot.value as? NSDictionary
            CurrentUser.shared.username = userDic?["username"] as! String
            CurrentUser.shared.isFirstVisit = userDic?["isFirstVisit"] as! Bool
            CurrentUser.shared.profileImageUrl = userDic?["profileImageUrl"] as! String
            
            print("Login:username? \(CurrentUser.shared.username)")
            print("Login:IsFirstTime? \(CurrentUser.shared.isFirstVisit )")
        })
    }
    
    class func getUsersRef() -> FIRDatabaseReference {
        return FIRDatabase.database().reference(withPath:"users")
    }
    
    class func getCurrentUserRef() -> FIRDatabaseReference {
        return getUsersRef().child(getCurrentUser().uid)
    }
    
    class func getCurrentUser() -> FIRUser {
        return (FIRAuth.auth()?.currentUser)!
    }
    
    
}
