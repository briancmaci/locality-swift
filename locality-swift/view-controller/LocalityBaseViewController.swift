//
//  LocalityBaseViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/2/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseAuth

class LocalityBaseViewController: UIViewController, LocalityHeaderViewDelegate, SlideNavigationControllerDelegate, AlertViewDelegate {
    
    var header:FeedHeaderView!
    var alertView:AlertView!
    
    //var viewDidLoadCalled:Bool = false
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardOnTouchedOut()
        loadHeaderView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadHeaderView() {
        header = FeedHeaderView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: K.Screen.Width, height: K.NumberConstant.Header.HeroCollapseHeight)))
        
        header.delegate = self
    }
    
    func alertEmailValidate() {
        print("ALERT!!!!")
        showAlertView(title: K.String.Alert.Title.Verify.localized,
                      message: K.String.Alert.Message.Verify.localized,
                      close: K.String.Alert.Close.OK.localized,
                      action: K.String.Alert.Action.Resend.localized)
    }
    
    // MARK: - LocalityHeaderDelegate
    func iconTapped(btn: HeaderIconButton) {
        //print("Icon type? \(btn.iconType)")
        
        let type:HeaderIconType = btn.iconType
        
        switch type {
            
        case .back:
            //SlideNavigationController.sharedInstance().popViewController(animated: true)
            _ = SlideNavigationController.sharedInstance().popViewController(animated: true)
            
        case .close:
            print("Close Button Clicked")
    
        case .feedMenu:
            //this pops for now until we get the sliding menu feature in
            //SlideNavigationController.sharedInstance().popViewController(animated: true)
            _ = navigationController?.popViewController(animated: true)
            
        case .hamburger:
            //load posts & likes
            
            updateLeftMenuPostsAndLikes()
            SlideNavigationController.sharedInstance().open(MenuLeft, withCompletion: { 
                //print("nav slid open")
            })
        
        case .settings:
            print("feed settings")
            
        case .none:
            print("Do Nothing")
        }
    }
    
    func updateLeftMenuPostsAndLikes() {
        let leftMenu = SlideNavigationController.sharedInstance().leftMenu as! LeftMenuViewController
        leftMenu.loadTotals()
    }
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }

    func showAlertView(title: String, message: String, close: String, action: String = "") {
        
        alertView = UIView.instanceFromNib(name: "AlertView") as! AlertView
        alertView.setup(title: title, message: message, closeTitle: close, actionTitle: action)
        alertView.delegate = self
        
        view.addSubview(alertView)
    }
    
    func tappedAction() {
        //override
        FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (error) in
            if error == nil {
                //Email validation resent
                self.alertView.closeAlert()
            }
        })
    }
}
