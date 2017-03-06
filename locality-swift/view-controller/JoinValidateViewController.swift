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
        
        if FIRAuth.auth()?.currentUser?.isEmailVerified == false {
            
            alertEmailValidate()
            return
            
        }
        
        else {
            print("SET ISFIRSTTIME SOMEWHERE!!!!!")
            
            let newVC:CurrentFeedInitializeViewController = AppUtilities.getViewControllerFromStoryboard(id: K.Storyboard.ID.CurrentFeedInit) as! CurrentFeedInitializeViewController
            
            navigationController?.pushViewController(newVC, animated: true)
        }
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
