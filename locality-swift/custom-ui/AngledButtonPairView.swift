//
//  AngledButtonPairView.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/1/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

protocol AngledButtonPairDelegate {
    func leftButtonDidTouch()
    func rightButtonDidTouch()
}

class AngledButtonPairView: UIView {

    var buttonLeft : AngledPairButton!
    var buttonRight : AngledPairButton!
    
    var attrLeft : AngledButtonAttributes!
    var attrRight : AngledButtonAttributes!
    
    var delegate : AngledButtonPairDelegate?
    
    func setAttributesAndBuild( left:AngledButtonAttributes, right:AngledButtonAttributes) {
        
        //This is colored in the Storyboard for ease of viewing. We clear now.
        backgroundColor = .clear
        
        attrLeft = left
        attrRight = right
        
        buildButtonLeft()
        buildButtonRight()
        addButtonActions()
    }
    
    //Build viewLeft as left-side rounded rect. Build viewRight with triangle.
    func buildButtonLeft() {
        let buttonFrame = CGRect(x:0,
                                 y:0,
                                 width:(frame.size.width + K.NumberConstant.RoundedButtonAngleWidth)/2,
                                 height:(frame.size.height))
        
        
        buttonLeft = AngledPairButton(frame:buttonFrame, isLeft:true, attributes:attrLeft)
        addSubview(buttonLeft)
        
    }
    
    func buildButtonRight() {
        let buttonFrame = CGRect(x:(frame.size.width - K.NumberConstant.RoundedButtonAngleWidth)/2,
                                 y:0,
                                 width:(frame.size.width + K.NumberConstant.RoundedButtonAngleWidth)/2,
                                 height:(frame.size.height))
        
        
        buttonRight = AngledPairButton(frame:buttonFrame, isLeft:false, attributes:attrRight)
        addSubview(buttonRight)
    }
    
    func addButtonActions() {
        buttonLeft.addTarget(self,
                             action: #selector(pairButtonDidTouch),
                             for: .touchUpInside)
        
        buttonRight.addTarget(self,
                             action: #selector(pairButtonDidTouch),
                             for: .touchUpInside)
    }
    
    // MARK: - Left/Right Button Actions
    
    func pairButtonDidTouch(sender:AngledPairButton) {
        
        if sender.isLeftButton == true {
            delegate?.leftButtonDidTouch()
        }
        
        else {
            delegate?.rightButtonDidTouch()
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
