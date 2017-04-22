//
//  LoadingView.swift
//  locality-swift
//
//  Created by Chelsea Power on 4/22/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    private var backgroundView: UIView!
    private var activityIndicator: LocalityRefreshCustomView!
    private var loadingLabel: UILabel!
    
    let kLabelFontSize: CGFloat = 14
    let kBackgroundAlpha: CGFloat = 0.4

    private func initLoadingView() {
        
        backgroundColor = .clear
        
        initBackground()
        initActivityIndicator()
        initLoadingLabel()
    }
    
    private func initBackground() {
    
        backgroundView = UIView(frame: frame)
        backgroundView.backgroundColor = K.Color.localityLightBlue
        backgroundView.alpha = kBackgroundAlpha
        
        addSubview(backgroundView)
    }
    
    private func initActivityIndicator() {
        
        activityIndicator = LocalityRefreshCustomView()
    }
    
    private func initLoadingLabel() {
        
    }
    
    public func showLoading() {
        
        initLoadingView()
    }
    
    public func hideLoading() {
        
    }
}
