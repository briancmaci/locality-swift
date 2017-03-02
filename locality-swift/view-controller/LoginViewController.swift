//
//  LoginViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 2/28/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth

class LoginViewController: LocalityBaseViewController, FBSDKLoginButtonDelegate {
    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
     */
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Facebook logged out")
    }

    
    //@IBOutlet weak var loginButton:FBSDKLoginButton!

    @IBOutlet weak var loginButtonContainer:UIView!
    
    var loginButton:FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["email"]
        loginButton.delegate = self
        
        let loginButtonFrame = CGRect(x:(loginButtonContainer.frame.size.width - loginButton.frame.size.width)/2,
                                      y:(loginButtonContainer.frame.size.height - loginButton.frame.size.height)/2,
                                      width:loginButton.frame.size.width,
                                      height:loginButton.frame.size.height)
        
        loginButton.frame = loginButtonFrame
        
        loginButtonContainer.addSubview(loginButton)
        
        if FBSDKAccessToken.current() != nil {
        
            // User is logged in, do work such as go to next view controller.
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - FBSDKLoginButtonDelegate Methods
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        //success! Get token for Firebase authentication
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // user logged into Firebase
            if let error = error {
                // user login error
                print("User login error: \(error.localizedDescription)")
                return
            }
        }
        
    }
    
}

