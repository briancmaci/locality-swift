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
    
    var authListenerHandle:FIRAuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initButtons()
        initButtonAnimation()
        
        // Do any additional setup after loading the view.
        authListenerHandle = FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            
            if user != nil {
                FirebaseManager.loadCurrentUserModel { (success) in
                    if success == true {
                        self.moveToNextView()
                    }
                    
                    else {
                        self.initParallax()
                        self.animateButtonsIn()
                    }
                }
            }
            
            else {
                self.initParallax()
                self.animateButtonsIn()
            }
        }        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FIRAuth.auth()?.removeStateDidChangeListener(authListenerHandle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveToNextView() {
        
        print("In moveToNextView")
        
        if FIRAuth.auth()?.currentUser?.isEmailVerified == false {
            
            if CurrentUser.shared.password.isEmpty && CurrentUser.shared.facebookToken.isEmpty {
                do {
                    try FIRAuth.auth()?.signOut()
                    
                    //Now log backed in based on how we logged out
                    let vc = LoginViewController(nibName: K.NIBName.VC.Login, bundle: nil)
                    SlideNavigationController.sharedInstance().pushViewController(vc, animated: true)
                    
                } catch {
                    print("Auth.signOut failed")
                }
            } else {
                
                let vc = JoinValidateViewController(nibName: K.NIBName.VC.JoinValidate, bundle: nil)
                SlideNavigationController.sharedInstance().pushViewController(vc, animated: true)
            }
        } else {
        
            if CurrentUser.shared.isFirstVisit == true {
                let vc = CurrentFeedInitializeViewController(nibName: K.NIBName.VC.CurrentFeedInit, bundle: nil)
                SlideNavigationController.sharedInstance().pushViewController(vc, animated: true)
                
            } else {
                
                let menuVc = FeedMenuTableViewController(nibName: K.NIBName.VC.FeedMenu, bundle: nil)
                
                SlideNavigationController.sharedInstance().popAllAndSwitch(to: menuVc, withCompletion: nil)
                
                let vc = FeedViewController(nibName: K.NIBName.VC.Feed, bundle: nil)
                vc.thisFeed = CurrentUser.shared.currentLocationFeed
                SlideNavigationController.sharedInstance().pushViewController(vc, animated: false)
                
            }
        }
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
        let vc = JoinViewController(nibName: K.NIBName.VC.Join, bundle: nil)
        SlideNavigationController.sharedInstance().pushViewController(vc, animated: true)
    }
    
    func rightButtonDidTouch() {
        let vc = LoginViewController(nibName: K.NIBName.VC.Login, bundle: nil)
        SlideNavigationController.sharedInstance().pushViewController(vc, animated: true)
    }
    
    override func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
}
