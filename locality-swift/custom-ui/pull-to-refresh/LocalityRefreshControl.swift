//
//  LocalityRefreshControl.swift
//  PullToRefresh-Locality
//
//  Created by Chelsea Power on 4/1/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class LocalityRefreshControl: UIRefreshControl {

    let kRadarSize: CGFloat = 30
    
    var customView: LocalityRefreshCustomView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func create() {
        initCustomView()
    }
    
    func initCustomView() {
        
        tintColor = .clear
        
        customView = LocalityRefreshCustomView(frame: CGRect(x:(UIScreen.main.bounds.width - kRadarSize) / 2,
                                                             y: (bounds.height - kRadarSize) / 2,
                                                             width: kRadarSize,
                                                             height: kRadarSize))
        
        customView.create()
        addSubview(customView)
    }
    
    func animate(_ val: Bool) {
        
        if val == true {
            customView.animate(true)
        } else {
            customView.animate(false)
        }
    }
}
