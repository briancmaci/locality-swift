//
//  UIImageExtension.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import Foundation

extension UIImage {

    func tinted(color:UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        color.setFill()
        let bounds = CGRect(origin:CGPoint.zero, size:self.size)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: .multiply, alpha: 1.0)
        
        let tintedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return tintedImage
    }
}
