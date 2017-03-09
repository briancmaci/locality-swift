//
//  FeedViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/8/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class FeedViewController: LocalityBaseViewController {

    @IBOutlet weak var headerContainer:UIView!
    
    var header:FlexibleFeedHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initHeaderView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initHeaderView() {
        
        header = UIView.instanceFromNib(name: K.NIBName.FlexibleFeedHeaderView) as! FlexibleFeedHeaderView
        
        header.frame = CGRect(x:0, y:0, width:headerContainer.frame.size.width, height:headerContainer.frame.size.height)
        headerContainer.addSubview(header)
        
        //header.initHeaderViewStage()
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
