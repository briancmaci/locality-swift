//
//  JoinValidateViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/3/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseAuth

class JoinValidateViewController: LocalityBaseViewController {

    @IBOutlet weak var loginButton:UIButton!
    @IBOutlet weak var loginError:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initErrorFields()
        initButtons()
        
        sendEmailVerification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initErrorFields() {
        loginError.text?.removeAll()
    }
    
    func initButtons() {
        loginButton.addTarget(self, action: #selector(loginDidTouch), for: .touchUpInside)
    }
    
    func loginDidTouch(sender:UIButton) {
        
        FirebaseManager.getCurrentUserRef().observeSingleEvent(of: .value, with: { (snapshot) in
            print("single event observed? \(snapshot)")
        })
        FirebaseManager.getCurrentUserRef().observe(.childChanged) { (snapshot) in
            print("CHILD CHANGED? \(snapshot.value)")
        }
        if FirebaseManager.getCurrentUser().isEmailVerified == false {
            
            alertEmailValidate()
            return
            
        }
        
        else {
            print("SET ISFIRSTTIME SOMEWHERE!!!!!")
            
            let newVC:CurrentFeedInitializeViewController = AppUtilities.getViewControllerFromStoryboard(id: K.Storyboard.ID.CurrentFeedInit) as! CurrentFeedInitializeViewController
            
            navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    func sendEmailVerification() {
        FirebaseManager.getCurrentUser().sendEmailVerification(completion: { (error) in
            if error == nil {
//                let newVC:JoinValidateViewController = AppUtilities.getViewControllerFromStoryboard(id: K.Storyboard.ID.JoinValidate) as! JoinValidateViewController
//                self.navigationController?.pushViewController(newVC, animated: true)
            }
        })
    }
}
