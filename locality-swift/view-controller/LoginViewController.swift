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

class LoginViewController: LocalityBaseViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var emailField:UITextField!
    @IBOutlet weak var passwordField:UITextField!
    
    @IBOutlet weak var loginEmailButton:UIButton!
    
    @IBOutlet weak var emailError:UILabel!
    @IBOutlet weak var passwordError:UILabel!

    @IBAction func loginDidTouch(sender:UIButton) {
    
        loginButton.sendActions(for: .touchUpInside)
    }
    
    var loginButton:FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if FBSDKAccessToken.current() != nil {
        
            // User is logged in, do work such as go to next view controller.
        }
        
        initButtons()
        initErrorFields()
        initTextFields()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initButtons() {
        loginEmailButton.addTarget(self, action: #selector(emailDidTouch), for: .touchUpInside)
        
        loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["email"]
        loginButton.delegate = self
    }
    
    func initErrorFields() {
        emailError.text?.removeAll()
        passwordError.text?.removeAll()
    }
    
    func initTextFields() {
        emailField.delegate = self
        passwordField.delegate = self
        
        emailField.addTarget(self, action: #selector(textFieldDidChange), for:.editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldDidChange), for:.editingChanged)
        
        emailField.clearsOnBeginEditing = true
        passwordField.clearsOnBeginEditing = true
        
    }
    
    //Firebase Sign Up
    func loginViaEmail() {
        FIRAuth.auth()?.signIn(withEmail: emailField.text!,
                                   password: passwordField.text!,
                                   completion: { (user, error) in
                                    if error == nil {
                                        
                                        print("Logged in user: \(user)")
                                        
                                        self.moveToCurrentFeedView()
                                    }
                                            
                                    else {
                                        print("Login Error: \(error?.localizedDescription)")
                                        self.displayFirebaseError(error: error!, forEmail: true)
                                    }
                                    
        })
    }
    
    func displayFirebaseError(error:Error, forEmail:Bool) {
        if let errorCode = FIRAuthErrorCode(rawValue: (error._code)){
            
            switch errorCode {
            case .errorCodeInvalidEmail:
                emailError.text = K.String.Error.EmailInvalid
                
            case .errorCodeUserDisabled:
                emailError.text = K.String.Error.UserDisabled
                
            case .errorCodeWrongPassword:
                passwordError.text = K.String.Error.PasswordWrong
                
            case .errorCodeEmailAlreadyInUse:
                emailError.text = forEmail == true ? K.String.Error.EmailInUseEmail :
                                                     K.String.Error.EmailInUseFacebook
                
            default:break
            }
        }
    }
    
    func moveToCurrentFeedView() {
        print("!!!We need to test isFirstTime, username, validation!!!")
        
        let newVC:CurrentFeedInitializeViewController = AppUtilities.getViewControllerFromStoryboard(id: K.Storyboard.ID.CurrentFeedInit) as! CurrentFeedInitializeViewController
        
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    // CTA
    func emailDidTouch(sender:UIButton) {
        
        loginViaEmail()
    }
    
    func textFieldDidChange(sender:UITextField) {
        if sender == emailField {
            emailError.text?.removeAll()
        }
            
        else {
            passwordError.text?.removeAll()
        }
    }
    
    // MARK - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
    
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
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
            if error == nil {
                self.moveToCurrentFeedView()
            }
            
            else {
                // user login error
                print("User login error: \(error?.localizedDescription)")
                self.displayFirebaseError(error: error!, forEmail: false)
                return
            }
        }
    }
    
    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
     */
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Facebook logged out")
    }
    
}

