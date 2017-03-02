//
//  AngledPairButton.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/1/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class AngledPairButton: UIButton {

    var isLeftButton : Bool!
    var attr : AngledButtonAttributes!
    
    required init(frame:CGRect, isLeft:Bool, attributes:AngledButtonAttributes) {
        
        isLeftButton = isLeft
        attr = attributes
        
        super.init(frame : frame)
    
        setTitle(attr.title, for: .normal)
        setTitleColor(attr.titleColor, for: .normal)
        titleLabel?.font = UIFont(name: attr.fontName, size: attr.fontSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        var path:UIBezierPath!
        
        if isLeftButton == true {
            path = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.bottomLeft, .topLeft],
                                    cornerRadii: CGSize(width: K.NumberConstant.RoundedButtonCornerRadius,
                                                        height: K.NumberConstant.RoundedButtonCornerRadius))
        }
        
        else {
            
            //create easier vars to read for width and height
            let width = frame.size.width
            let height = frame.size.height
            //Build custom angled button edge
            path = UIBezierPath()
            path.move(to: CGPoint(x:0, y:height))
            path.addLine(to: CGPoint(x:K.NumberConstant.RoundedButtonAngleWidth/2, y:0))
            path.addLine(to: CGPoint(x:width - K.NumberConstant.RoundedButtonCornerRadius, y:0))
            
            path.addCurve(to: CGPoint(x:width, y:K.NumberConstant.RoundedButtonCornerRadius),
                          controlPoint1:CGPoint(x:width - K.NumberConstant.RoundedButtonCornerRadius/2,
                                                y:0),
                          controlPoint2:CGPoint(x:width,
                                                y:K.NumberConstant.RoundedButtonCornerRadius/2))
            
            path.addLine(to: CGPoint(x:width,
                                     y:height - K.NumberConstant.RoundedButtonCornerRadius))
           
            path.addCurve(to: CGPoint(x:width - K.NumberConstant.RoundedButtonCornerRadius,
                                      y:height),
                          controlPoint1:CGPoint(x:width,
                                                y:height - K.NumberConstant.RoundedButtonCornerRadius/2),
                          controlPoint2:CGPoint(x:width  - K.NumberConstant.RoundedButtonCornerRadius/2,
                                                y:height))

            path.addLine(to: CGPoint(x:0, y:height))
            path.close()
        }
        
        attr.backgroundColor.setFill()
        path.fill()
    }
}
