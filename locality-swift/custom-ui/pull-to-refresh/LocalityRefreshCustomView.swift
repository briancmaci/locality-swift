//
//  LocalityRefreshCustomView.swift
//  PullToRefresh-Locality
//
//  Created by Chelsea Power on 4/1/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class LocalityRefreshCustomView: UIView {

    let kCircles = 3
    let kRotationAnimationKey = "RadarSpinnerRotation"
    let bgColor = K.Color.pullToRefreshColor
    let spinnerColor = K.Color.pullToRefreshSpinnerColor
    
    var radarBackground: UIView!
    var radarSpinner: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        create()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func create() {
        
        initRadarBackground()
        initRadarSpinner()
        animate(true)
    }
    
    func initRadarBackground() {
        radarBackground = UIView(frame: bounds)
        drawRadarBackground()
        addSubview(radarBackground)
    }
    
    func initRadarSpinner() {
        radarSpinner = UIView(frame: bounds)
        drawRadarSpinner()
        addSubview(radarSpinner)
    }
    
    func animate(_ val:Bool) {
        
        if val == true {
            rotateView(view: radarSpinner, duration: 0.7)
        }
        
        else {
            stopRotatingView(view: radarSpinner)
        }
    }

    func rotateView(view: UIView, duration: Double = 1) {
        if view.layer.animation(forKey: kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
    
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Double.pi * 2
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
    
            view.layer.add(rotationAnimation, forKey: kRotationAnimationKey)
        }
    }
    
    func stopRotatingView(view: UIView) {
        if view.layer.animation(forKey: kRotationAnimationKey) != nil {
            view.layer.removeAnimation(forKey: kRotationAnimationKey)
        }
    }
    
    func drawRadarBackground() {
        
        drawBackgroundLines()
        
        //draw concentric circles
        for i in 1...kCircles-1 {
            drawBackgroundCircle(radius: ((bounds.width / 2) / CGFloat(kCircles)) * CGFloat(i))
        }
    }
    
    func drawBackgroundLines() {
        
        let lines = CAShapeLayer()
        let crossPath = UIBezierPath()
        
        lines.strokeColor = bgColor.cgColor
        lines.lineWidth = 1
        
        crossPath.move(to: CGPoint(x: radarBackground.center.x, y: 0))
        crossPath.addLine(to: CGPoint(x: radarBackground.center.x, y: radarBackground.bounds.height))
        
        crossPath.move(to: CGPoint(x: 0, y: radarBackground.center.y))
        crossPath.addLine(to: CGPoint(x: radarBackground.bounds.width, y: radarBackground.center.y))
        
        crossPath.close()
        
        lines.path = crossPath.cgPath
        radarBackground.layer.addSublayer(lines)
        
    }
    
    func drawBackgroundCircle(radius: CGFloat) {
        
        let circle = CAShapeLayer()
        let circlePath = UIBezierPath()
        
        let north = CGPoint(x: radarBackground.center.x, y: radarBackground.center.y - radius)
        let east = CGPoint(x: radarBackground.center.x + radius, y: radarBackground.center.y )
        let south = CGPoint(x: radarBackground.center.x, y: radarBackground.center.y + radius)
        let west = CGPoint(x: radarBackground.center.x - radius, y: radarBackground.center.y )
        
        circle.strokeColor = bgColor.cgColor
        circle.fillColor = UIColor.clear.cgColor
        circle.lineWidth = 1
        
        circlePath.move(to: north)
        circlePath.addCurve(to: east,
                            controlPoint1: CGPoint(x: north.x + (radius / 2), y: north.y),
                            controlPoint2: CGPoint(x: east.x, y: east.y - (radius / 2)))
        
        circlePath.addCurve(to: south,
                            controlPoint1: CGPoint(x: east.x, y: east.y + (radius / 2)),
                            controlPoint2: CGPoint(x: south.x + (radius / 2), y: south.y))
        
        circlePath.addCurve(to: west,
                            controlPoint1: CGPoint(x: south.x - (radius / 2), y: south.y),
                            controlPoint2: CGPoint(x: west.x, y: west.y + (radius / 2)))
        
        circlePath.addCurve(to: north,
                            controlPoint1: CGPoint(x: west.x, y: west.y - (radius / 2)),
                            controlPoint2: CGPoint(x: north.x - (radius / 2), y: north.y))
        
        circlePath.close()
        
        circle.path = circlePath.cgPath
        radarBackground.layer.addSublayer(circle)
        
    }
    
    func drawRadarSpinner() {
        
        let radarSlice = CAShapeLayer()
        let slicePath = UIBezierPath()
        
        radarSlice.strokeColor = bgColor.cgColor
        radarSlice.fillColor = spinnerColor.cgColor
        radarSlice.lineWidth = 1
        
        slicePath.move(to: CGPoint(x: radarSpinner.center.x, y: radarSpinner.center.y))
        slicePath.addLine(to: CGPoint(x: radarSpinner.bounds.width, y: radarSpinner.center.y))
        slicePath.addArc(withCenter: CGPoint(x: radarSpinner.center.x, y: radarSpinner.center.y),
                         radius: radarSpinner.bounds.width/2, startAngle: 0.0, endAngle: -45.0 * CGFloat(Double.pi / 180), clockwise: false)
        slicePath.addLine(to: CGPoint(x: radarSpinner.center.x, y: radarSpinner.center.y))
        
        slicePath.close()
        
        radarSlice.path = slicePath.cgPath
        radarSpinner.layer.addSublayer(radarSlice)
    }
    

}
