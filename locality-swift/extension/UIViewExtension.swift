//
//  UIViewExtension.swift
//  locality-swift
//
//  Created by Brian Maci on 3/1/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

extension UIView {

    class func instanceFromNib(name: String) -> UIView {
        return UINib(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
