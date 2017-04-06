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
    
    @IBOutlet weak var loginEmailButton:LoadingButton!
    @IBOutlet weak var loginFacebookButton:LoadingButton!
    
    @IBOutlet weak var forgotPasswordButton:UIButton!
    
    @IBOutlet weak var emailError:UILabel!
    @IBOutlet weak var passwordError:UILabel!
    @IBOutlet weak var facebookError:UILabel!
    
    var isLoadingView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FBSDKAccessToken.current() != nil {
        
            // User is logged in, do work such as go to next view controller.
            print("Facebook already authenticated")
        }
        
        initButtons()
        initHeaderView()
        initErrorFields()
        initTextFields()
        initLoadingView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initButtons() {
        loginEmailButton.addTarget(self, action: #selector(emailDidTouch), for: .touchUpInside)
        loginFacebookButton.addTarget(self, action: #selector(facebookDidTouch), for: .touchUpInside)
        
        forgotPasswordButton.setTitle(K.String.Login.ForgotPasswordLabel.localized, for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(passwordForgotDidTouch), for: .touchUpInside)

    }
    
    func initHeaderView() {
        header.initHeaderViewStage()
        header.initAttributes(title: "", leftType: .back, rightType: .none)
        header.backgroundColor = .clear
        view.addSubview(header)
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
    
    func initLoadingView() {
        isLoadingView = UIView(frame: CGRect(x:0, y:0, width:K.Screen.Width, height:K.Screen.Height))
        isLoadingView.backgroundColor = K.Color.localityLightBlue
        isLoadingView.alpha = 0.3
    }
    
    //Firebase Sign Up
    func loginViaEmail() {
        loginEmailButton.showLoading()
        toggleLoading(true)
        FIRAuth.auth()?.signIn(withEmail: emailField.text!,
                                   password: passwordField.text!,
                                   completion: { (user, error) in
                                    
                                    self.loginEmailButton.hideLoading()
                                    self.toggleLoading(false)
                                    
                                    if error == nil {
                                        
                                        //for email verifiy logout/login
                                        CurrentUser.shared.password = self.passwordField.text!
                                        
                                        self.loadCurrentUserVars()
                                    }
                                            
                                    else {
                                        self.displayFirebaseError(error: error!, forEmail: true)
                                    }
                                    
        })
    }
    
    func loadCurrentUserVars() {
        
        //FInd out if this is the first time
        FirebaseManager.loadCurrentUserModel { (success) in
            
            if success == true {
                self.moveToNextView()
            }
                
            else {
                print("Something is fucked up")
            }
        }
    }
    
    func moveToNextView() {
        
        //check email verification
        if FirebaseManager.getCurrentUser().isEmailVerified == false {
            
            let newVC:JoinValidateViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.JoinValidate) as! JoinValidateViewController
            
            SlideNavigationController.sharedInstance().pushViewController(newVC, animated: true)
            return
        }
        
        if CurrentUser.shared.isFirstVisit == true {
            let newVC:CurrentFeedInitializeViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.CurrentFeedInit) as! CurrentFeedInitializeViewController
            
            SlideNavigationController.sharedInstance().pushViewController(newVC, animated: true)
        }
            
        else {
            
            // ADD Feed Menu First!!
            let feedMenuVC:FeedMenuTableViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.FeedMenu) as! FeedMenuTableViewController
            
            SlideNavigationController.sharedInstance().popAllAndSwitch(to: feedMenuVC, withCompletion: nil)
            
            let newVC:FeedViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.Feed) as! FeedViewController
            
            newVC.thisFeed = CurrentUser.shared.currentLocationFeed
            SlideNavigationController.sharedInstance().pushViewController(newVC, animated: false)
            
        }
    }
    
    // CTA
    func emailDidTouch(sender:UIButton) {
        
        loginViaEmail()
    }
    
    func facebookDidTouch(sender:UIButton) {
        loginViaFacebook()
    }
    
    func passwordForgotDidTouch(sender:UIButton) {
        
        let newVC:ForgotPasswordViewController = ForgotPasswordViewController(nibName: K.NIBName.ForgotPasswordViewController, bundle: nil)
        
        navigationController?.present(newVC, animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
    
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == passwordField {
            forgotPasswordButton.isHidden = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordField {
            if textField.text?.isEmpty == true {
                forgotPasswordButton.isHidden = false
            }
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: - FBSDKLoginButtonDelegate Methods
    func loginViaFacebook() {
        
        loginFacebookButton.showLoading()
        toggleLoading(true)
        
        let login = FBSDKLoginManager()
        
        login.logIn(withReadPermissions: ["public_profile"], from: self, handler: { (result, error) in
            
            
            if (error != nil || (result?.isCancelled)!) {
                print("Facebook Login Error \(String(describing: error?.localizedDescription))")
                self.loginFacebookButton.hideLoading()
                self.toggleLoading(false)
            } else {
                
                // Log in to Firebase via Facebook
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: (result?.token.tokenString)!)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    
                    self.loginFacebookButton.hideLoading()
                    self.toggleLoading(false)
                    
                    if (error != nil) {
                        print("Facebook Firebase Login Error \(String(describing: error?.localizedDescription))")
                    }
                    
                    else {
                        
                        //Save token
                        CurrentUser.shared.facebookToken = (result?.token.tokenString)!
                        
                        FirebaseManager.getCurrentUserRef().child(K.DB.Var.Username).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            //let thisUsername = snapshot.value as! String
                            if !snapshot.exists() {
                                let newVC:JoinUsernameViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.JoinUser) as! JoinUsernameViewController
                                
                                SlideNavigationController.sharedInstance().pushViewController(newVC, animated: true)
                            }
                            
                            else {
                                self.loadCurrentUserVars()
                            }
                        })
                        
                    }
                }
            }
        })
    }

    func toggleLoading(_ isLoading:Bool) {
    
        if isLoading == true {
            view.addSubview(isLoadingView)
        }
        
        else {
            isLoadingView.removeFromSuperview()
        }
    }
    
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
                
            case .errorCodeUserNotFound:
                emailError.text = K.String.Error.NoSuchEmail.localized
                break
                
            default:
                emailError.text = K.String.Error.SomethingWentWrong.localized
                break
            }
        }
    }
    
    override func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
}

