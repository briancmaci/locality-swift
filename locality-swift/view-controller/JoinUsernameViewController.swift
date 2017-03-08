//
//  JoinUsernameViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/3/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class JoinUsernameViewController: LocalityBaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField:UITextField!
    @IBOutlet weak var usernameError:UILabel!
    @IBOutlet weak var continueButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initErrorFields()
        initTextFields()
        initButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initErrorFields() {
        usernameError.text?.removeAll()
    }
    
    func initTextFields() {
        usernameField.delegate = self
        usernameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        usernameField.clearsOnBeginEditing = true
    }
    
    func initButtons() {
        continueButton.addTarget(self, action: #selector(continueDidTouch), for: .touchUpInside)
    }
    
    // CTAs
    func continueDidTouch(sender:UIButton) {
        
        //check for unique username
        FirebaseManager.getUsersRef().observeSingleEvent(of: .value, with: { snapshot in
            var usernameIsUnique = true
            
            if snapshot.value is NSNull {
                usernameIsUnique = true

            } else {
                let usersArray = snapshot.value as! [String:AnyObject]
                for user in usersArray {
                    let thisUsername = user.value["username"] as? String
                    
                    if thisUsername?.lowercased() == self.usernameField.text!.lowercased() {
                        usernameIsUnique = false
                        
                    }
                }
            }
            
            if usernameIsUnique == true {
                
                self.onboardCurrentUserModel()
                
                let newVC:JoinValidateViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.JoinValidate) as! JoinValidateViewController
                
                self.navigationController?.pushViewController(newVC, animated: true)
            }
            
            else {
                //username match
                self.usernameError.text = K.String.Error.UsernameTaken.localized
            }
        })
    }
    
    func onboardCurrentUserModel() {
        
        //let changeRequest = FirebaseManager.getCurrentUser().profileChangeRequest()
        
        CurrentUser.shared.email = FirebaseManager.getCurrentUser().email!
        CurrentUser.shared.uid = FirebaseManager.getCurrentUser().uid
        CurrentUser.shared.username = self.usernameField.text!
        
//        changeRequest.displayName = CurrentUser.shared.displayName
//        changeRequest.photoURL = URL(string:CurrentUser.shared.profileImageUrl)
//        changeRequest.commitChanges { error in
//            if error != nil {
//                print("Change request failed: \(error?.localizedDescription)")
//            } else {
//                print("Profile updated")
//                print(FirebaseManager.getCurrentUser().displayName)
//            }
//        }
        
        FirebaseManager.getCurrentUserRef().updateChildValues(CurrentUser.shared.extraAttributesToFirebase()) { (error, ref) in
            if error != nil {
                print("Extra Attributes update failed: \(error?.localizedDescription)")
            } else {
                print("Extra Attributes updated")
            }
        }
    }
    
    func textFieldDidChange(sender:UITextField) {
        usernameError.text?.removeAll()
    }
    
    // MARK: - UITextFieldDelegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
