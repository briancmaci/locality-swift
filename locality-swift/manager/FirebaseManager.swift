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
}
