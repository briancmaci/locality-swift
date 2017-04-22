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
    let kBackgroundAlpha: CGFloat = 0.75
    let kActivityIndicatorSize: CGFloat = 60

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLoadingView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLoadingView() {
        
        backgroundColor = .clear
        
        initBackground()
        initActivityIndicator()
        initLoadingLabel()
    }
    
    private func initBackground() {
    
        backgroundView = UIView(frame: frame)
        backgroundView.backgroundColor = .white
        backgroundView.alpha = kBackgroundAlpha
        
        addSubview(backgroundView)
    }
    
    private func initActivityIndicator() {
        
        activityIndicator = LocalityRefreshCustomView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: kActivityIndicatorSize, height: kActivityIndicatorSize)))
        activityIndicator.center = center
        addSubview(activityIndicator)
    }
    
    private func initLoadingLabel() {
        
        loadingLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: frame.size.width, height: kLabelFontSize + 4)))
        loadingLabel.font = UIFont(name: K.FontName.InterstateLightCondensed, size: kLabelFontSize)
        loadingLabel.textColor = K.Color.localityBlue
        loadingLabel.textAlignment = .center
        loadingLabel.center = CGPoint(x: center.x, y: center.y + kActivityIndicatorSize / 2 + 8)
        
        
        addSubview(loadingLabel)
    }
    
    public func updateLoading(label: String) {
        
        loadingLabel.text = label
    }
}
