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

        // Do any additional setup after loading the view.
        
        initErrorFields()
        initTextFields()
        initButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let usersRef = FIRDatabase.database().reference(withPath:"users")
        
        usersRef.observeSingleEvent(of: .value, with: { snapshot in
            var usernamesMatched = false
            
            if snapshot.value is NSNull {
                usernamesMatched = false

            } else {
                let usersArray = snapshot.value as! [String:AnyObject]
                for user in usersArray {
                    let thisUsername = user.value["username"] as! String
                    
                    //case sensitivity
                    if thisUsername.lowercased() == self.usernameField.text!.lowercased() {
                        usernamesMatched = true
                        
                    }
                }
                
            }
            
            if usernamesMatched == false {
                
                //unique username!
                FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).setValue(["username": self.usernameField.text])
                
                FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (error) in
                    if error == nil {
                        //email verification sent
                        let newVC:JoinValidateViewController = AppUtilities.getViewControllerFromStoryboard(id: K.Storyboard.ID.JoinValidate) as! JoinValidateViewController
                        
                        self.navigationController?.pushViewController(newVC, animated: true)
                    }
                })
            }
            
            else {
                //username match
                self.usernameError.text = K.String.Error.UsernameTaken.localized
            }
        })
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
