//
//  UIViewControllerExtension.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/2/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardOnTouchedOut() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
