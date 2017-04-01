//
//  LocalityBaseViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/2/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseAuth

class LocalityBaseViewController: UIViewController, LocalityHeaderViewDelegate, SlideNavigationControllerDelegate {
    
    var header:FeedHeaderView!
    
    var viewDidLoadCalled:Bool = false
    
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
        
        let alert = UIAlertController(title: K.String.Alert.VerifyTitle.localized,
                                      message: K.String.Alert.VerifyMessage.localized,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let confirmAction = UIAlertAction(title: K.String.Alert.VerifyButton0.localized,
                                          style: .default) { (action) in
            
            FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (error) in
                if error == nil {
                    //Email validation resent
                    alert.dismiss(animated: true, completion: nil)
                }
            })
        }
        
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
