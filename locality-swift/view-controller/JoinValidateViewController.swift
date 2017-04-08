//
//  JoinValidateViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/3/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseAuth

class JoinValidateViewController: LocalityBaseViewController {

    @IBOutlet weak var loginButton:UIButton!
    @IBOutlet weak var loginError:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initErrorFields()
        initButtons()
        initHeaderView()
        
        sendEmailVerification()
        
        //initVerifiedListener()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initHeaderView() {
        header.initHeaderViewStage()
        header.initAttributes(title: "", leftType: .back, rightType: .none)
        header.backgroundColor = .clear
        view.addSubview(header)
    }
    
    func initErrorFields() {
        loginError.text?.removeAll()
    }
    
    func initButtons() {
        loginButton.addTarget(self, action: #selector(loginDidTouch), for: .touchUpInside)
    }
    
    func loginDidTouch(sender:UIButton) {
        if FirebaseManager.getCurrentUser().isEmailVerified == false {
            
            //attempt logout, login
            
            do {
                try FIRAuth.auth()?.signOut()
                print("LOGGED OUT!")
                
                //Now log backed in based on how we logged out
                
                if !CurrentUser.shared.password.isEmpty {
                
                    FIRAuth.auth()?.signIn(withEmail: CurrentUser.shared.email, password: CurrentUser.shared.password, completion: { (user, error) in
                        if error == nil {
                            print("IsEmailVerified POST Login? \(String(describing: user?.isEmailVerified))")
                            
                            if user?.isEmailVerified == true {
                                self.goToFeedInitialize()
                            } else {
                                self.alertEmailValidate()
                            }
                        } else {
                            print("JoinValidate relogin error: \(String(describing: error?.localizedDescription))")
                        }
                        
                    })
                } else {
                    
                    let credential = FIRFacebookAuthProvider.credential(withAccessToken: CurrentUser.shared.facebookToken)
                    FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                        
                        if (error != nil) {
                            print("Facebook Firebase Login Error \(String(describing: error?.localizedDescription))")
                        } else {
                            if user?.isEmailVerified == true {
                                self.goToFeedInitialize()
                            } else {
                                self.alertEmailValidate()
                            }
                        }
                    }
                }
                
            } catch {
                print("Auth.signOut failed")
            }
            //alertEmailValidate()
            return
            
        } else {
            goToFeedInitialize()
        }
    }
    
    func sendEmailVerification() {
        FirebaseManager.getCurrentUser().sendEmailVerification(completion: { (error) in
            if error == nil {

            }
        })
    }
    
    func goToFeedInitialize() {
    
        let vc = CurrentFeedInitializeViewController(nibName: K.NIBName.VC.CurrentFeedInit, bundle: nil)
        SlideNavigationController.sharedInstance().pushViewController(vc, animated: true)
    }
    
    override func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
}
