//
//  CGFloatExtension.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/11/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import Foundation

extension CGFloat {
    func roundTo(places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
            return (self * divisor).rounded() / divisor
    }
}
