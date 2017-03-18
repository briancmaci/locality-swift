//
//  AboutViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/17/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class AboutViewController: LocalityBaseViewController {

    @IBOutlet weak var aboutLabel:UILabel!
    @IBOutlet weak var shareLabel:UILabel!
    @IBOutlet weak var facebookButton:UIButton!
    @IBOutlet weak var twitterButton:UIButton!
    @IBOutlet weak var googlePlusButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initButtons()
        initLabels()
        initHeaderView()
    }
    
    func initButtons() {
        facebookButton.addTarget(self,
                                 action: #selector(facebookDidTouch),
                                 for: .touchUpInside)
        
        twitterButton.addTarget(self,
                                action: #selector(twitterDidTouch),
                                for: .touchUpInside)
        
        googlePlusButton.addTarget(self,
                                   action: #selector(googlePlusDidTouch),
                                   for: .touchUpInside)
    }
    
    func initHeaderView() {
        header.initHeaderViewStage()
        header.initAttributes(title: "", leftType: .hamburger, rightType: .none)
        header.backgroundColor = .clear
        view.addSubview(header)
    }
    
    func initLabels() {
        
        aboutLabel.text = K.String.About.AboutCopy.localized
        aboutLabel.setLineHeight(lineHeight: 10)
        shareLabel.text = K.String.About.AboutShareLabel.localized
    }
    
    //CTA
    func facebookDidTouch(sender:UIButton) {
        print("Share to Facebook")
    }
    
    func twitterDidTouch(sender:UIButton) {
        print("Share to Twitter")
    }
    
    func googlePlusDidTouch(sender:UIButton) {
        print("Share to Google+")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
