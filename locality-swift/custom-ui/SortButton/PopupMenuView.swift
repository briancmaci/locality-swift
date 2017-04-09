//
//  PopupMenuView.swift
//  PopupMenu
//
//  Created by Chelsea Power on 3/17/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class PopupMenuView: UIView {
    
    var btns:[PopupButtonView]!
    
    convenience init(btn:[PopupButtonView]) {
        self.init(frame:CGRect.zero)
        
        self.btns = btn
        
        self.frame = CGRect(origin: CGPoint.zero,
                       size: CGSize(width:kPopButtonWidth * CGFloat(btns.count),
                                    height:kButtonHeight))
        
        var btnFrame:CGRect!
        
        for i in 0...btn.count-1 {
            btnFrame = CGRect(x:kPopButtonWidth*CGFloat(i), y:0, width:kPopButtonWidth, height:kButtonHeight)
            btns[i].frame = btnFrame
            
            self.addSubview(btns[i])
            
            //add pinline
            if i != 0 {
                self.addSubview(createPinlineAt(index: i))
            }
        }
        
        self.layer.mask = buildPopupMask()
    }
    
    func createPinlineAt(index:Int) -> UIView {
        let pinline = UIView(frame:CGRect(x:kPopButtonWidth * CGFloat(index), y:0, width:1, height:kButtonHeight - kPointHeight))
        pinline.backgroundColor = K.Color.sortPin
        
        return pinline
    }
    
    func buildPopupMask() -> CAShapeLayer {
        
        let cornerRadius:CGFloat = 3
        //create easier vars to read for width and height
        let width = frame.size.width
        let height = frame.size.height
        
        let path:UIBezierPath = UIBezierPath()
        
        
        path.move(to: CGPoint(x:cornerRadius, y:0))
        path.addLine(to: CGPoint(x:width - cornerRadius, y:0))
        path.addCurve(to: CGPoint(x:width, y:cornerRadius),
                      controlPoint1:CGPoint(x:width - cornerRadius/2,
                                            y:0),
                      controlPoint2:CGPoint(x:width,
                                            y:cornerRadius/2))
        
        path.addLine(to: CGPoint(x:width,
                                 y:height-kPointHeight - cornerRadius))
        
        path.addCurve(to: CGPoint(x:width - cornerRadius,
                                  y:height-kPointHeight),
                      controlPoint1:CGPoint(x:width,
                                            y:height-kPointHeight - cornerRadius/2),
                      controlPoint2:CGPoint(x:width  - cornerRadius/2,
                                            y:height-kPointHeight))
        
        path.addLine(to: CGPoint(x:kPopButtonWidth/2 + kPointHeight, y:height-kPointHeight))
        path.addLine(to: CGPoint(x:kPopButtonWidth/2, y:height))
        path.addLine(to: CGPoint(x:kPopButtonWidth/2 - kPointHeight, y:height-kPointHeight))
        path.addLine(to: CGPoint(x:cornerRadius , y:height-kPointHeight))
        path.addCurve(to: CGPoint(x:0,
                                  y:height-kPointHeight - cornerRadius),
                      controlPoint1:CGPoint(x:cornerRadius/2,
                                            y:height-kPointHeight),
                      controlPoint2:CGPoint(x:0,
                                            y:height-kPointHeight - cornerRadius/2))
        path.addLine(to: CGPoint(x:0, y:cornerRadius))
        path.addCurve(to: CGPoint(x:cornerRadius,
                                  y:0),
                      controlPoint1:CGPoint(x:0,
                                            y:cornerRadius/2),
                      controlPoint2:CGPoint(x:cornerRadius/2,
                                            y:0))
        path.close()
        
        let pathMask = CAShapeLayer()
        pathMask.path = path.cgPath
        
        return pathMask
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
