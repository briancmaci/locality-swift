//
//  AlertView.swift
//  locality-swift
//
//  Created by Chelsea Power on 4/2/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

@objc protocol AlertViewDelegate {
    
    @objc optional func tappedAction()
    
}

class AlertView: UIView {

    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var alert: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var buttonsView: UIView!
    
    @IBOutlet weak var alertMargin: NSLayoutConstraint!
    @IBOutlet weak var alertHeight: NSLayoutConstraint!
    @IBOutlet weak var messageHeight: NSLayoutConstraint!
    
    let kButtonWidth: CGFloat = 120
    let kButtonHeight: CGFloat = 30
    let kButtonPadding: CGFloat = 20
    
    var closeButton:AlertViewButton!
    var actionButton:AlertViewButton?
    
    var delegate:AlertViewDelegate?
    
    func setup(title: String, message: String, closeTitle: String, actionTitle: String = "") {
        
        setupLabels(title: title, message: message)
        setupButtons(close: closeTitle, action: actionTitle)
        sizeAlert()
    }
    
    func setupLabels(title: String, message: String ) {
        
        titleLabel.text = title.uppercased()
        messageLabel.text = message
        messageHeight.constant = messageLabel.requiredHeight()
        layoutIfNeeded()
    }
    
    func setupButtons(close: String, action: String) {
        
        closeButton = AlertViewButton(frame: makeButtonFrame(), title: close)
        closeButton.addTarget(self, action: #selector(tappedCloseButton), for: .touchUpInside)
        
        if !action.isEmpty {
            actionButton = AlertViewButton(frame: makeButtonFrame(), title: action)
            actionButton?.addTarget(self, action: #selector(tappedActionButton), for: .touchUpInside)
        }
        
        
        //place buttons
        if actionButton != nil {
            var actionFrame = actionButton?.frame
            actionFrame?.origin.x = (buttonsView.frame.size.width - kButtonPadding) / 2 - kButtonWidth
            actionButton?.frame = actionFrame!
            
            buttonsView.addSubview(actionButton!)
            
            var closeFrame = closeButton.frame
            closeFrame.origin.x = (buttonsView.frame.size.width + kButtonPadding) / 2
            closeButton.frame = closeFrame
            
            buttonsView.addSubview(closeButton)
        } else {
            var closeFrame = closeButton.frame
            closeFrame.origin.x = (buttonsView.frame.size.width - kButtonWidth) / 2
            closeButton.frame = closeFrame
            
            buttonsView.addSubview(closeButton)
        }
    }
    
    func sizeAlert() {
    
        alertHeight.constant = buttonsView.frame.origin.y + buttonsView.frame.size.height + alertMargin.constant
        layoutIfNeeded()
    }
    
    //CTA
    func tappedCloseButton(sender:AlertViewButton) {
        
        closeAlert()
    }
    
    func tappedActionButton(sender:AlertViewButton) {
        
        delegate?.tappedAction!()
    }
    
    //Public
    func closeAlert() {
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.alpha = 0
        }) { (success) in
            self.removeTargets()
            self.removeFromSuperview()
        }
    }
    
    //Helpers
    func makeButtonFrame() -> CGRect {
        return CGRect(origin: CGPoint.zero,
                      size: CGSize(width: kButtonWidth, height: kButtonHeight))
    }
    
    func removeTargets() {
        
        closeButton.removeTarget(self, action: #selector(tappedCloseButton), for: .touchUpInside)
        
        if actionButton != nil {
            actionButton?.removeTarget(self, action: #selector(tappedActionButton), for: .touchUpInside)
        }
    }
}
