//
//  RangeStep.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/5/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class RangeStep: NSObject {
    
    var distance:CGFloat = 0
    var label:String = ""
    var unit:String = ""
    
    init(distance:CGFloat, label:String, unit:String) {
        super.init()
        
        self.distance = distance
        self.label = label
        self.unit = unit
    }
}
