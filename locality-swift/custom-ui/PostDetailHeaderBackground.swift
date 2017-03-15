//
//  PostDetailHeaderBackground.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/14/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class PostDetailHeaderBackground: UIView {

    override func draw(_ rect: CGRect) {
        
        UIGraphicsGetCurrentContext()!.clear(self.bounds)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.white.cgColor)
        
        
        context.setShadow(offset: CGSize(width:0, height:K.NumberConstant.Post.ShadowOffset),
                          blur: K.NumberConstant.Post.ShadowBlur,
                          color: K.Color.leftNavLight.cgColor)
        
        context.setLineWidth(0)
        context.move(to: CGPoint.zero)
        
        context.addLine(to: CGPoint(x:bounds.size.width, y:0))
        
        context.addLine(to: CGPoint(x:bounds.size.width, y:bounds.size.height - K.NumberConstant.Post.PointHeight - K.NumberConstant.Post.ShadowOffset))
        
        context.addLine(to: CGPoint(x:(bounds.size.width + K.NumberConstant.Post.PointWidth)/2,
                                    y:bounds.size.height - K.NumberConstant.Post.PointHeight - K.NumberConstant.Post.ShadowOffset))
        
        context.addLine(to: CGPoint(x:bounds.size.width/2,
                                    y:bounds.size.height - K.NumberConstant.Post.ShadowOffset))
        
        context.addLine(to: CGPoint(x:(bounds.size.width - K.NumberConstant.Post.PointWidth)/2,
                                    y: bounds.size.height - K.NumberConstant.Post.PointHeight - K.NumberConstant.Post.ShadowOffset))
        
        context.addLine(to: CGPoint(x:0,
                                    y: bounds.size.height - K.NumberConstant.Post.PointHeight - K.NumberConstant.Post.ShadowOffset))
        
        context.addLine(to: CGPoint.zero)
        
        context.closePath()
        
        context.drawPath(using: .fillStroke)
    }
}
