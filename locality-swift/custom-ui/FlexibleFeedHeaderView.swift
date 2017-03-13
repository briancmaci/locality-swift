//
//  FlexibleFeedHeaderView.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/8/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class FlexibleFeedHeaderView: FeedHeaderView {    

    @IBOutlet weak var locationLabel:UILabel!
    @IBOutlet weak var openFeedButton:UIButton!
    @IBOutlet weak var shadowOverlay:UIImageView!
    
    var feedModel:FeedLocation!
    var feedIndex:Int!
    
    let deltaHeight = K.NumberConstant.Header.HeroExpandHeight - K.NumberConstant.Header.HeroCollapseHeight
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed(K.NIBName.FlexibleFeedHeaderView, owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    func populate(model:FeedLocation, index:Int, inFeedMenu:Bool) {
        
        feedModel = model
        feedIndex = index
        
        initImage()
        initButton()
        initIcons(inMenu:inFeedMenu)
        initLabels()
    }
    
    func initImage() {
        if feedModel.feedImgUrl != K.Image.DefaultFeedHero {
            heroImageView.sd_setImage(with: URL(string:feedModel.feedImgUrl), completed: { (image, error, cacheType, imageURL) in
                
                if (cacheType == .disk || cacheType == .none) {
                    self.heroImageView.alpha = 0
                    UIView.animate(withDuration: 0.25, animations: { 
                        self.heroImageView.alpha = 1
                    })
                }
                
                else {
                    self.heroImageView.alpha = 1
                }
            })
        }
        
        else {
            self.heroImageView.image = UIImage(named:K.Image.DefaultFeedHero)
            self.shadowOverlay.isHidden = true
        }
    }
    
    func initButton() {
    
        openFeedButton.addTarget(self, action: #selector(openFeedDidTouch), for: .touchUpInside)
    }
    
    func initIcons(inMenu:Bool) {
        initAttributes(title: feedModel.name == K.String.CurrentFeedName ? K.String.Header.CurrentLocationTitle.localized : feedModel.name.uppercased(),
                       leftType: inMenu ? .none : .hamburger,
                       rightType: inMenu ? .settings : .feedMenu)
        
        updateIconsY()
    }
    
    func initLabels() {
        locationLabel.text = feedModel.location.uppercased()
    }
    
    func updateIconsY() {
        
        if let lButton = leftIconButton {
            var lFrame = lButton.frame
            
            lFrame.origin.y = feedNameTop.constant + (titleLabel.frame.size.height - lButton.frame.size.height)/2
            
            lButton.frame = lFrame
        }
        
        if let rButton = rightIconButton {
            var rFrame = rButton.frame
            
            rFrame.origin.y = feedNameTop.constant + (titleLabel.frame.size.height - rButton.frame.size.height)/2
            
            rButton.frame = rFrame
        }
    }
   
    //CTA
    func openFeedDidTouch(sender:UIButton) {
        
        delegate?.openFeedTapped?(model: feedModel, index: feedIndex)
    }
    
    func updateHeaderHeight(newHeight:CGFloat) {
        headerHeight.constant = newHeight
        locationLabel.alpha = (newHeight - K.NumberConstant.Header.HeroCollapseHeight)/deltaHeight
        
        feedNameTop.constant = K.NumberConstant.Header.TitleY0 + (K.NumberConstant.Header.TitleY1 * ((newHeight - K.NumberConstant.Header.HeroCollapseHeight)/K.NumberConstant.Header.HeroExpandHeight))
        
        updateIconsY()
        setNeedsUpdateConstraints()
    }
}
