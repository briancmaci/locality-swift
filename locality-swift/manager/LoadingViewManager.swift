//
//  LoadingViewManager.swift
//  locality-swift
//
//  Created by Chelsea Power on 4/22/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class LoadingViewManager: NSObject {

    static var loadingView: LoadingView!
    
    class func showLoading(label: String = "") {
        
        if loadingView == nil {
            
            loadingView = LoadingView(frame: UIScreen.main.bounds)
        }
        
        updateLoading(label: label)
        UIApplication.shared.keyWindow?.addSubview(loadingView)
    }
    
    class func updateLoading(label: String) {
        
        loadingView.updateLoading(label: label)
    }
    
    class func hideLoading() {
        
        loadingView.removeFromSuperview()
    }
}
