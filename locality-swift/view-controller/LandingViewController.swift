//
//  LandingViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/1/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LandingViewController: LocalityBaseViewController, AngledButtonPairDelegate {

    @IBOutlet weak var exploreButton : RoundedRectangleButton!
    @IBOutlet weak var joinLoginButtonPairView : AngledButtonPairView!
    
    @IBOutlet weak var leftParallaxStretch:NSLayoutConstraint!
    @IBOutlet weak var rightParallaxStretch:NSLayoutConstraint!
    @IBOutlet weak var topParallaxStretch:NSLayoutConstraint!
    @IBOutlet weak var bottomParallaxStretch:NSLayoutConstraint!
    
    @IBOutlet weak var contourLines:UIImageView!
    
    //Used for button animation
    @IBOutlet weak var joinLoginBottom : NSLayoutConstraint!
    @IBOutlet weak var exploreBottom : NSLayoutConstraint!
    
    let kParallaxRange:CGFloat = 60.0
    let buttonGap : CGFloat = 10
    
    var joinLoginY0 : CGFloat!
    var joinLoginY1 : CGFloat!
    var exploreY0 : CGFloat!
    var exploreY1 : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                //print("Landing:WE ARE AUTHENTICATED!")
                FirebaseManager.getCurrentUserRef().child(K.DB.Var.IsFirstVisit).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let isFirstVisit = snapshot.value as? Bool {
                        print("Landing:IsFirstVisit= \(isFirstVisit)")
                    }
                    
                    else {
                        //print("Landing:ViewDidLoad():isFirstVisit null")
                    }
                })
            }
        }
        
        initButtons()
        initButtonAnimation()
        initParallax()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateButtonsIn()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initParallax(){
    
        // Set stretch of contour lines
        leftParallaxStretch.constant = -kParallaxRange/2
        rightParallaxStretch.constant = -kParallaxRange/2
        topParallaxStretch.constant = -kParallaxRange/2
        bottomParallaxStretch.constant = -kParallaxRange/2
        
        contourLines.setNeedsUpdateConstraints()
        
        //Set vertical effect
        let verticalMotionEffect:UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = NSNumber(floatLiteral: -(Double)(kParallaxRange))
        verticalMotionEffect.maximumRelativeValue = NSNumber(floatLiteral: Double(kParallaxRange))
        
        //Set horizontal effect
        let horizontalMotionEffect:UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = NSNumber(floatLiteral: -(Double)(kParallaxRange))
        horizontalMotionEffect.maximumRelativeValue = NSNumber(floatLiteral: Double(kParallaxRange))
        
        //Combine effects
        let group:UIMotionEffectGroup = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        contourLines.addMotionEffect(group)
    }
    
    func initButtons() {
        
        //AppUtilities.printFonts()
        exploreButton.setAttributes(title:K.String.Button.LandingExplore.localized,
                                    titleColor:K.Color.landingButtonGray,
                                    backgroundColor:.white)
        
        exploreButton.addTarget(self, action: #selector(exploreButtonDidTouch), for: .touchUpInside)
        
        let leftAttributes:AngledButtonAttributes =
            AngledButtonAttributes(title:K.String.Button.LandingJoin.localized,
                                   titleColor:.white,
                                   backgroundColor:K.Color.localityBlue)
        
        let rightAttributes:AngledButtonAttributes =
            AngledButtonAttributes(title:K.String.Button.LandingLogin.localized,
                                   titleColor:K.Color.localityBlue,
                                   backgroundColor:K.Color.localityLightBlue)
        
        joinLoginButtonPairView.setAttributesAndBuild(left: leftAttributes, right: rightAttributes)
        joinLoginButtonPairView.delegate = self
    }
    
    func initButtonAnimation() {
    
        //init animate-in values
        exploreY0 = -joinLoginButtonPairView.frame.size.height
        exploreY1 = exploreBottom.constant
        
        joinLoginY0 = (exploreY0 * 2) - buttonGap
        joinLoginY1 = joinLoginBottom.constant
        
        exploreBottom.constant = exploreY0
        joinLoginBottom.constant = joinLoginY0
        
        view.layoutIfNeeded()
    }
    
    func animateButtonsIn() {
    
        exploreBottom.constant = exploreY1
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: { self.view.layoutIfNeeded() },
                       completion:nil)
        
        joinLoginBottom.constant = joinLoginY1
        UIView.animate(withDuration: 0.55,
                       delay: 0.1,
                       options: [.curveEaseOut],
                       animations: { self.view.layoutIfNeeded() },
                       completion:nil)
    }
    
    //CTAs
    func exploreButtonDidTouch(sender:RoundedRectangleButton) {
        print("Explore button touched")
    }
    
    //MARK: - AngledButtonPairDelegate
    func leftButtonDidTouch() {
        let newVC : JoinViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.Join) as! JoinViewController
        
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    func rightButtonDidTouch() {
        let newVC : LoginViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.Login) as! LoginViewController
        
        navigationController?.pushViewController(newVC, animated: true)
    }
}
