//
//  UpdateUsernameViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 4/22/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Firebase

class UpdateUsernameViewController: LocalityBaseViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    
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
        
        changeButton.addTarget(self, action: #selector(changeButtonDidTouch), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeDidTouch), for: .touchUpInside)
    }
    
    func initTextFields() {
        usernameField.delegate = self
        errorLabel.text?.removeAll()
    }
    
    //CTA
    func changeButtonDidTouch(sender:UIButton) {
        
        usernameField.resignFirstResponder()
        
        if usernameField.text == "" {
            errorLabel.text = K.String.Error.UsernameEmpty.localized
            return
        }
        
        FirebaseManager.getUsersRef().observeSingleEvent(of: .value, with: { snapshot in
            var usernameIsUnique = true
            
            if snapshot.value is NSNull {
                usernameIsUnique = true
                
            } else {
                let usersArray = snapshot.value as! [String:AnyObject]
                for user in usersArray {
                    let thisUsername = user.value[K.DB.Var.Username] as? String
                    
                    if thisUsername?.lowercased() == self.usernameField.text!.lowercased() {
                        usernameIsUnique = false
                        
                    }
                }
            }
            
            if usernameIsUnique == true {
                self.updateUsername()
            }
                
            else {
                //username match
                self.errorLabel.text = K.String.Error.UsernameTaken.localized
            }
        })
    }
    
    func closeDidTouch(sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateUsername() {
        
        CurrentUser.shared.username = usernameField.text!
        
        FirebaseManager.getCurrentUserRef().updateChildValues(CurrentUser.shared.extraAttributesToFirebase()) { (error, ref) in
            if error != nil {
                print("Extra Attributes update failed: \(String(describing: error?.localizedDescription))")
            } else {
                print("Extra Attributes updated")
                self.usernameChangeComplete()
            }
        }
    }
    
    func usernameChangeComplete() {
        changeButton.setTitle(K.String.Username.UsernameChangedLabel.localized, for: .normal)
        
        _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.dismiss(animated: true, completion: nil)
            timer.invalidate()
        }
    }
    
    //UITextFieldDelegate
    func textFieldDidChange(sender:UITextField) {
        
        errorLabel.text?.removeAll()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        errorLabel.text?.removeAll()
    }
    
    //Errors
    func displayFirebaseError(error:Error) {
        if let errorCode = FIRAuthErrorCode(rawValue: (error._code)){
            
            print("Error code? \(error.localizedDescription)")
//            switch errorCode {
//            case .errorCodeInvalidEmail:
//                emailErrorLabel.text = K.String.Error.EmailInvalid.localized
//                
//            case .errorCodeUserNotFound:
//                emailErrorLabel.text = K.String.Error.NoSuchEmail.localized
//                
//            default:break
//            }
        }
    }
}
