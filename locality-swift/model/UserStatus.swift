//
//  UserStatus.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/2/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

enum UserStatusType:Int {
    case newUser = 0, contributor, reporter, columnist, trustedSource
}

class UserStatus: NSObject {

    class func stringFrom(type:UserStatusType) -> String {
    
        switch type {
        
        case .newUser:
            return K.String.UserStatus.NewUser.localized
            
        case .contributor:
            return K.String.UserStatus.Contributor.localized
            
        case .reporter:
            return K.String.UserStatus.Reporter.localized
            
        case .columnist:
            return K.String.UserStatus.Columnist.localized
            
        case .trustedSource:
            return K.String.UserStatus.TrustedSource.localized
        
        }
    }
    
    class func statusTypeFrom(string:String) -> UserStatusType {
        
        switch string {
        
        case K.String.UserStatus.NewUser.localized:
            return .newUser
            
        case K.String.UserStatus.Contributor.localized:
            return .contributor
            
        case K.String.UserStatus.Reporter.localized:
            return .reporter
            
        case K.String.UserStatus.Columnist.localized:
            return .columnist
            
        case K.String.UserStatus.TrustedSource.localized:
            return .trustedSource
            
        default:
            return .newUser
            
        }
    }
}
