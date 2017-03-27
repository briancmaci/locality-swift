//
//  ForgotPasswordViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/26/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var sendEmailButton:UIButton!
    @IBOutlet weak var closeModalButton:UIButton!
    @IBOutlet weak var emailField:UITextField!
    @IBOutlet weak var emailErrorLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
     
    }
    
    //Initial Setup
    func initialSetup() {
        
        initButtons()
        initTextFields()
    }
    
    func initButtons() {
        
        sendEmailButton.addTarget(self, action: #selector(sendEmailDidTouch), for: .touchUpInside)
        closeModalButton.addTarget(self, action: #selector(closeDidTouch), for: .touchUpInside)
    }
    
    func initTextFields() {
        emailField.delegate = self
        emailErrorLabel.text?.removeAll()
    }
    
    //CTA
    func sendEmailDidTouch(sender:UIButton) {
        
        emailField.resignFirstResponder()
        
        if emailField.text == "" {
            emailErrorLabel.text = K.String.Error.EmailEmpty.localized
            return
        }
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: emailField.text!, completion: { (error) in
            if error == nil {
                self.emailSentComplete()
            } else {
                self.displayFirebaseError(error: error!)
            }
        })
    }
    
    func closeDidTouch(sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func emailSentComplete() {
        sendEmailButton.setTitle(K.String.Login.EmailSentLabel.localized, for: .normal)
        
        _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.dismiss(animated: true, completion: nil)
            timer.invalidate()
        }
    }
    
    //UITextFieldDelegate
    func textFieldDidChange(sender:UITextField) {

        emailErrorLabel.text?.removeAll()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        emailErrorLabel.text?.removeAll()
    }
    
    //Errors
    func displayFirebaseError(error:Error) {
        if let errorCode = FIRAuthErrorCode(rawValue: (error._code)){
            
            print("Error code? \(error.localizedDescription)")
            switch errorCode {
            case .errorCodeInvalidEmail:
                emailErrorLabel.text = K.String.Error.EmailInvalid.localized
                
            case .errorCodeUserNotFound:
                emailErrorLabel.text = K.String.Error.NoSuchEmail.localized
                
            default:break
            }
        }
    }
}
