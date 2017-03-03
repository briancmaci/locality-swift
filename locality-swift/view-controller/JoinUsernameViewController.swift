//
//  JoinUsernameViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/3/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseAuth

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
    
    }
    
    // CTAs
    func usernameDidTouch(sender:UIButton) {
        //check for unique username
        
        //if unique then...
        FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (error) in
            if error == nil {
                print("Email verification sent")
            }
        })
    }
    
    func textFieldDidChange(sender:UITextField) {
        usernameError.text?.removeAll()
    }
    
    // MARK - UITextFieldDelegate Methods
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
