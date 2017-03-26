 //
//  FeedHeaderView.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/8/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

@objc protocol LocalityHeaderViewDelegate {
    @objc optional func iconTapped(btn:HeaderIconButton)
    @objc optional func editFeedTapped(model:FeedLocation)
    @objc optional func openFeedTapped(model:FeedLocation, index:Int)
}

class FeedHeaderView: UIView {
    
    @IBOutlet weak var view:UIView!

    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var heroImageView:UIImageView!
    
    @IBOutlet weak var headerHeight:NSLayoutConstraint!
    @IBOutlet weak var feedNameTop:NSLayoutConstraint!
    
    var leftIconButton:HeaderIconButton!
    var rightIconButton:HeaderIconButton!
    
    var delegate:LocalityHeaderViewDelegate?
    
//    override init(frame:CGRect) {
//        super.init(frame:frame)
//        
//        initHeaderViewStage()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func initHeaderViewStage() {
        backgroundColor = K.Color.localityBlue
        tintColor = .white
        
        heroImageView = UIImageView(frame: self.frame)
        addSubview(heroImageView)
        
        titleLabel = UILabel(frame:CGRect(x:0,
                                          y:K.NumberConstant.Header.TitleY0,
                                          width:K.Screen.Width,
                                          height:K.NumberConstant.Header.TitleHeight))
        
        titleLabel.font = UIFont(name: K.FontName.InterstateLightCondensed,
                                 size: K.NumberConstant.Header.FontSize)
        
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
    }
    
    func update(bg:UIImage) {
        heroImageView.image = bg
    }
    
    func setTitle(title:String) {
        if title != K.String.HeaderTitleLogo {
            titleLabel.text = title.uppercased()
        }
        
        else {
            titleLabel.text?.removeAll()
        }
    }
    
    func initAttributes(title:String, leftType:HeaderIconType, rightType:HeaderIconType) {
        setTitle(title:title)
        setLeftButton(type:leftType)
        setRightButton(type:rightType)
        
    }
    
    func setLeftButton(type:HeaderIconType) {
        
        if type == .none {
            return
        }
        
        leftIconButton = HeaderIconButton(type: type)
        leftIconButton.frame = CGRect(x:K.NumberConstant.Header.ButtonIndent,
                                      y:K.NumberConstant.Header.TitleY0 + (K.NumberConstant.Header.TitleHeight - leftIconButton.frame.size.height)/2,
                                      width:leftIconButton.frame.size.width,
                                      height:leftIconButton.frame.size.height)
        bindEvent(btn:leftIconButton)
        addSubview(leftIconButton)
        
        
    }
    
    func setRightButton(type:HeaderIconType) {
        
        if type == .none {
            return
        }
        
        rightIconButton = HeaderIconButton(type: type)
        rightIconButton.frame = CGRect(x:K.Screen.Width - K.NumberConstant.Header.ButtonIndent - rightIconButton.frame.size.width,
                                      y:K.NumberConstant.Header.TitleY0 + (K.NumberConstant.Header.TitleHeight - rightIconButton.frame.size.height)/2,
                                      width:rightIconButton.frame.size.width,
                                      height:rightIconButton.frame.size.height)
        bindEvent(btn:rightIconButton)
        addSubview(rightIconButton)
        
        
    }
    
    func bindEvent(btn:HeaderIconButton) {
        
        btn.addTarget(self, action: #selector(iconDidTouch), for: .touchUpInside)
    }
    
    func iconDidTouch(sender:HeaderIconButton) {
        
        delegate?.iconTapped!(btn: sender)
    }
}
