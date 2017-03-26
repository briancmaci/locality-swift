//
//  ForgotPasswordViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/26/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

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
    
    }
    
    func closeDidTouch(sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
