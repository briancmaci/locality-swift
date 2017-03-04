//
//  JoinValidateViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/3/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

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
        print("Check validation and enter Locality")
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