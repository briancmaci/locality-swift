//
//  FabricManager.swift
//  locality-swift
//
//  Created by Chelsea Power on 2/28/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit
import Mapbox

class FabricManager: NSObject {
    
    class func initFabric() {
        Fabric.with([Twitter.self, MGLAccountManager.self])
    }
}
