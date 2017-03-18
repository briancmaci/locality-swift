//
//  JoinViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/2/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class JoinViewController: LocalityBaseViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField:UITextField!
    @IBOutlet weak var passwordField:UITextField!
    @IBOutlet weak var confirmField:UITextField!

    @IBOutlet weak var registerEmailButton:UIButton!
    @IBOutlet weak var registerFacebookButton:UIButton!
    
    @IBOutlet weak var emailError:UILabel!
    @IBOutlet weak var passwordError:UILabel!
    @IBOutlet weak var facebookError:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initButtons()
        initErrorFields()
        initTextFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initButtons() {
        registerEmailButton.addTarget(self, action: #selector(emailDidTouch), for: .touchUpInside)
        registerFacebookButton.addTarget(self, action: #selector(facebookDidTouch), for: .touchUpInside)
    }
    
    func initErrorFields() {
        emailError.text?.removeAll()
        passwordError.text?.removeAll()
        facebookError.text?.removeAll()
    }
    
    func initTextFields() {
        emailField.delegate = self
        passwordField.delegate = self
        confirmField.delegate = self
        
        emailField.addTarget(self, action: #selector(textFieldDidChange), for:.editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldDidChange), for:.editingChanged)
        confirmField.addTarget(self, action: #selector(textFieldDidChange), for:.editingChanged)
        
        emailField.clearsOnBeginEditing = true
        passwordField.clearsOnBeginEditing = true
        confirmField.clearsOnBeginEditing = true
    
    }
    
    //Firebase Sign Up
    func registerViaEmail() {
        FIRAuth.auth()?.createUser(withEmail: emailField.text!,
                                   password: passwordField.text!,
                                   completion: { (user, error) in
                                        if error == nil {
                                            
            //fill shared currentUser
            //CurrentUser.shared.email = self.emailField.text!
            
            //let's auth now 
            FIRAuth.auth()?.signIn(withEmail: self.emailField.text!,
                                   password: self.passwordField.text!,
                                   completion: { (user, error) in
                                    if error == nil {
                                        
                                        //save password for emailVerify
                                        CurrentUser.shared.password = self.passwordField.text!
                                        
                                        //move to username
                                        let newVC:JoinUsernameViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.JoinUser) as! JoinUsernameViewController
                                        
                                        self.navigationController?.pushViewController(newVC, animated: true)
                                    }
                                    
                                    else {
                                        //Print error message from Firebase
                                        self.displayFirebaseError(error: error!)
                                    }
                })
            }
        
            else {
                //Print error message from Firebase
                self.displayFirebaseError(error: error!)
                print("Error Code: \(error?._code)")
            }
        })
    }
    
    func displayFirebaseError(error:Error) {
        if let errorCode = FIRAuthErrorCode(rawValue: (error._code)){
        
            switch errorCode {
            case .errorCodeInvalidEmail:
            emailError.text = K.String.Error.EmailInvalid.localized
                
            case .errorCodeEmailAlreadyInUse:
            emailError.text = K.String.Error.EmailDuplicate.localized
                
            case .errorCodeWeakPassword:
                passwordError.text = K.String.Error.PasswordTooWeak.localized
                
            default:break
            }
        }
    }
    
    // CTA
    func emailDidTouch(sender:UIButton) {
        
        var hasErrors:Bool = false
        
        //Test empty email
        if emailField.text == "" {
            emailError.text = K.String.Error.EmailEmpty.localized
            hasErrors = true
        }
        
        //Test for password consistency
        if passwordField.text == "" && confirmField.text == "" {
            passwordError.text = K.String.Error.PasswordEmpty.localized
            hasErrors = true
        }
        
        else if passwordField.text != confirmField.text {
            passwordError.text = K.String.Error.PasswordMismatch.localized
            hasErrors = true
        }
        
        if hasErrors == false {
            registerViaEmail()
        }
    }
    
    func facebookDidTouch(sender:UIButton) {
        registerViaFacebook()
    }
    
    func registerViaFacebook() {
        let login = FBSDKLoginManager()
        
        
        login.logIn(withReadPermissions: ["public_profile"], from: self, handler: { (result, error) in
            
            
            if (error != nil || (result?.isCancelled)!) {
                print("Facebook Login Error \(error?.localizedDescription)")
            } else {
                
                // Log in to Firebase via Facebook
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: (result?.token.tokenString)!)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    
                    if (error != nil) {
                        //Print error message from Firebase
                        self.displayFirebaseError(error: error!)
                    }
                        
                    else {
                        print("Logged in FB user: \(user)")
                        
                        //save password for emailVerify
                        CurrentUser.shared.facebookToken = (result?.token.tokenString)!
                        
                        //move to username
                        let newVC:JoinUsernameViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.JoinUser) as! JoinUsernameViewController
                        
                        self.navigationController?.pushViewController(newVC, animated: true)
                    }
                }
            }
        })
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
        
        else if textField == passwordField {
            confirmField.becomeFirstResponder()
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
