//
//  EmergencyIcon.swift
//  locality-swift
//
//  Created by Chelsea Power on 4/23/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class EmergencyIcon: UIView {

    var squareWidth: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        squareWidth = rect.size.width / 5
        drawBackground()
        drawCross()
    }
    
    func drawBackground() {
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(K.Color.toggleRed.cgColor)
        context.setLineWidth(0)
        
        context.addArc(center: CGPoint(x: frame.size.width / 2, y: frame.size.width / 2),
                       radius: frame.size.width / 2,
                       startAngle: CGFloat(0),
                       endAngle: CGFloat(Double.pi * 2),
                       clockwise: true)
        
        context.closePath()
        context.drawPath(using: .fillStroke)
    }
    
    func drawCross() {
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.white.cgColor)
        context.setLineWidth(0)
        
        context.move(to: CGPoint(x: squareWidth * 2, y: squareWidth * 1))
        
        context.addLine(to: CGPoint(x: squareWidth * 3, y: squareWidth * 1))
        context.addLine(to: CGPoint(x: squareWidth * 3, y: squareWidth * 2))
        context.addLine(to: CGPoint(x: squareWidth * 4, y: squareWidth * 2))
        context.addLine(to: CGPoint(x: squareWidth * 4, y: squareWidth * 3))
        context.addLine(to: CGPoint(x: squareWidth * 3, y: squareWidth * 3))
        context.addLine(to: CGPoint(x: squareWidth * 3, y: squareWidth * 4))
        context.addLine(to: CGPoint(x: squareWidth * 2, y: squareWidth * 4))
        context.addLine(to: CGPoint(x: squareWidth * 2, y: squareWidth * 3))
        context.addLine(to: CGPoint(x: squareWidth * 1, y: squareWidth * 3))
        context.addLine(to: CGPoint(x: squareWidth * 1, y: squareWidth * 2))
        context.addLine(to: CGPoint(x: squareWidth * 2, y: squareWidth * 2))
        context.addLine(to: CGPoint(x: squareWidth * 2, y: squareWidth * 1))
        
        context.closePath()
        context.drawPath(using: .fillStroke)
    }
}
