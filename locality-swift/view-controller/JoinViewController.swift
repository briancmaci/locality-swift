//
//  JoinViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/2/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseAuth

class JoinViewController: LocalityBaseViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField:UITextField!
    @IBOutlet weak var passwordField:UITextField!
    @IBOutlet weak var confirmField:UITextField!
    
    @IBOutlet weak var registerEmailButton:UIButton!
    @IBOutlet weak var registerFacebookButton:UIButton!
    
    @IBOutlet weak var emailError:UILabel!
    @IBOutlet weak var passwordError:UILabel!
    
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
    func signUpViaEmail() {
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
                                                                        
                                                                        print("Logged in user: \(user)")
                                                                        //move to username
                                                                        let newVC:JoinUsernameViewController = AppUtilities.getViewControllerFromStoryboard(id: K.Storyboard.ID.JoinUser) as! JoinUsernameViewController
                                                                        
                                                                        self.navigationController?.pushViewController(newVC, animated: true)
                                                                    }
                                                                    
                                                                    else {
                                                                        print("Login Error: \(error?.localizedDescription)")
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
            emailError.text = K.String.Error.EmailInvalid
                
            case .errorCodeEmailAlreadyInUse:
            emailError.text = K.String.Error.EmailDuplicate
                
            case .errorCodeWeakPassword:
                passwordError.text = K.String.Error.PasswordTooWeak
                
            default:break
            }
        }
    }
    
    // CTA
    func emailDidTouch(sender:UIButton) {
        
        var hasErrors:Bool = false
        
        //Test empty email
        if emailField.text == "" {
            emailError.text = K.String.Error.EmailEmpty
            hasErrors = true
        }
        
        //Test for valid, unique email
//        else if emailField.text?.isValidEmail() != true {
//            emailError.text = K.String.Error.EmailInvalid
//            hasErrors = true
//        }
//        
//        else {
//            //check duplicate
//        }
        
        //Test for password consistency
        if passwordField.text == "" && confirmField.text == "" {
            passwordError.text = K.String.Error.PasswordEmpty
            hasErrors = true
        }
        
        else if passwordField.text != confirmField.text {
            passwordError.text = K.String.Error.PasswordMismatch
            hasErrors = true
        }
        
        if hasErrors == false {
            signUpViaEmail()
        }
    }
    
    func facebookDidTouch(sender:UIButton) {
        print("Register via Facebook")
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
        
        else if textField == passwordField {
            confirmField.becomeFirstResponder()
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
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
