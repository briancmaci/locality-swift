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

class LoginViewController: LocalityBaseViewController, /*FBSDKLoginButtonDelegate, */UITextFieldDelegate {
    
    @IBOutlet weak var emailField:UITextField!
    @IBOutlet weak var passwordField:UITextField!
    
    @IBOutlet weak var loginEmailButton:UIButton!
    @IBOutlet weak var loginFacebookButton:UIButton!
    
    @IBOutlet weak var emailError:UILabel!
    @IBOutlet weak var passwordError:UILabel!
    @IBOutlet weak var facebookError:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FBSDKAccessToken.current() != nil {
        
            // User is logged in, do work such as go to next view controller.
            print("Facebook already authenticated")
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
        loginFacebookButton.addTarget(self, action: #selector(facebookDidTouch), for: .touchUpInside)

    }
    
    func initErrorFields() {
        emailError.text?.removeAll()
        passwordError.text?.removeAll()
        facebookError.text?.removeAll()
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
                                        self.moveToCurrentFeedView()
                                    }
                                            
                                    else {
                                        self.displayFirebaseError(error: error!, forEmail: true)
                                    }
                                    
        })
    }
    
    func moveToCurrentFeedView() {
        
        //check email verification
        if FirebaseManager.getCurrentUser().isEmailVerified == false {
            let newVC:JoinValidateViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.JoinValidate) as! JoinValidateViewController
            
            navigationController?.pushViewController(newVC, animated: true)
            return
        }
        
        //FInd out if this is the first time
        FirebaseManager.loadCurrentUserModel()
        
        let newVC:CurrentFeedInitializeViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.CurrentFeedInit) as! CurrentFeedInitializeViewController
        
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    // CTA
    func emailDidTouch(sender:UIButton) {
        
        loginViaEmail()
    }
    
    func facebookDidTouch(sender:UIButton) {
        loginViaFacebook()
    }
    
    func textFieldDidChange(sender:UITextField) {
        if sender == emailField {
            emailError.text?.removeAll()
        }
            
        else if sender == passwordField {
            passwordError.text?.removeAll()
        }
        
        else {
            facebookError.text?.removeAll()
        }
    }
    
    // MARK: - UITextFieldDelegate
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
    
    // MARK: - FBSDKLoginButtonDelegate Methods
    func loginViaFacebook() {
        let login = FBSDKLoginManager()
        
        
        login.logIn(withReadPermissions: ["public_profile"], from: self, handler: { (result, error) in
            
            
            if (error != nil || (result?.isCancelled)!) {
                print("Facebook Login Error \(error?.localizedDescription)")
            } else {
                
                // Log in to Firebase via Facebook
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: (result?.token.tokenString)!)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    
                    if (error != nil) {
                        print("Facebook Firebase Login Error \(error?.localizedDescription)")
                    }
                    
                    else {
                        
                        FirebaseManager.getCurrentUserRef().child("username").observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            //let thisUsername = snapshot.value as! String
                            if !snapshot.exists() {
                                let newVC:JoinUsernameViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.JoinUser) as! JoinUsernameViewController
                                
                                self.navigationController?.pushViewController(newVC, animated: true)
                            }
                            
                            else {
                                //self.onboardCurrentUserModel()
                                self.moveToCurrentFeedView()
                            }
                        })
                        
                    }
                }
            }
        })
    }
    
//    func onboardCurrentUserModel() {
//        
//        CurrentUser.shared.email = (FIRAuth.auth()?.currentUser?.email)!
//        CurrentUser.shared.uid = (FIRAuth.auth()?.currentUser?.uid)!
//        
//        FirebaseManager.getCurrentUserRef().observeSingleEvent(of: .value, with: { (snapshot) in
//            let userDic = snapshot.value as? NSDictionary
//            
//            //grab extra attributes and write to model
//            CurrentUser.shared.username = userDic?["username"] as! String
//            CurrentUser.shared.isFirstVisit = userDic?["isFirstVisit"] as! Bool
//            CurrentUser.shared.profileImageUrl = userDic?["profileImageUrl"] as! String
//            print("Current User populated in onboardCurrentUserModel")
//            
//            print("USER DICTIONARY >>>>>>>>>>>>>>>>>>>>> \(userDic)")
//        })
//        
//        print("extra? \(CurrentUser.shared.extraAttributesToFirebase())")
//        FirebaseManager.getCurrentUserRef().updateChildValues(CurrentUser.shared.extraAttributesToFirebase()) { (error, ref) in
//            if error == nil {
//                print("FB Extra Attributes update failed: \(error?.localizedDescription)")
//            } else {
//                print("FB Extra Attributes updated")
//            }
//        }
//    }
    
    func displayFirebaseError(error:Error, forEmail:Bool) {
        if let errorCode = FIRAuthErrorCode(rawValue: (error._code)){
            
            switch errorCode {
            case .errorCodeInvalidEmail:
                emailError.text = K.String.Error.EmailInvalid.localized
                
            case .errorCodeUserDisabled:
                emailError.text = K.String.Error.UserDisabled.localized
                
            case .errorCodeWrongPassword:
                passwordError.text = K.String.Error.PasswordWrong.localized
                
            case .errorCodeEmailAlreadyInUse:
                if forEmail == true {
                    emailError.text = K.String.Error.EmailInUseEmail.localized
                }
                    
                else {
                    facebookError.text = K.String.Error.EmailInUseFacebook.localized
                }
                
            default:break
            }
        }
    }
}

