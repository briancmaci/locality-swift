//
//  FacebookManager.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/1/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FacebookManager: NSObject {

    class func initFacebookWith(app:UIApplication, options:[UIApplicationLaunchOptionsKey: Any]?) {
        
        FBSDKApplicationDelegate.sharedInstance().application(app, didFinishLaunchingWithOptions: options)
        
    }
}
