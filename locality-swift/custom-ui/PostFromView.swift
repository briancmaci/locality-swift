//
//  PostFromView.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class PostFromView: UIView {
    
    @IBOutlet weak var view:UIView!
    @IBOutlet weak var postFromMeToggle:PostFromViewToggle!
    @IBOutlet weak var postIncognitoToggle:PostFromViewToggle!
    
    var isAnonymous:Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed(K.NIBName.PostFromView, owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
        
        initToggles()
    }
    
//    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
//        super.awakeAfter(using: aDecoder)
//        initToggles()
//        
//        return self
//    }
    
    func initToggles() {
        postFromMeToggle.img.loadProfileImage(url: CurrentUser.shared.profileImageUrl)
        postFromMeToggle.img.encircled()
        postIncognitoToggle.setForMultiply()
        
        toggleToMe(yes:true)
        
        
    }
    
    func toggleToMe(yes:Bool) {
        postFromMeToggle.setSelected(yes: yes)
        postIncognitoToggle.setSelected(yes: !yes)
        
        isAnonymous = !yes
    }
    
    @IBAction func postFromMeDidTouch(sender:UIButton) {
        toggleToMe(yes:true)
    }
    
    @IBAction func postIcognitoDidTouch(sender:UIButton) {
        toggleToMe(yes:false)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
