//
//  LeftMenuViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/8/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {
    
    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var statusLabel:UILabel!
    
    @IBOutlet weak var likesLabel:UILabel!
    @IBOutlet weak var postsLabel:UILabel!
    
    //Constraints for likes and posts UILabels
    @IBOutlet weak var likesWidth:NSLayoutConstraint!
    @IBOutlet weak var postsWidth:NSLayoutConstraint!
    
    @IBOutlet weak var menuTable:UITableView!
    @IBOutlet weak var tableHeight:NSLayoutConstraint!
    
    @IBOutlet weak var termsButton:UIButton!
    @IBOutlet weak var copyrightLabel:UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
