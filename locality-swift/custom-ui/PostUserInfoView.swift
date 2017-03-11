//
//  PostUserInfoView.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class PostUserInfoView: UIView {
    
    @IBOutlet weak var view:UIView!
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var statusLabel:UILabel!
    @IBOutlet weak var profileImage:UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed(K.NIBName.PostUserInfoView, owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    func populate(imgUrl:String, username:String, status:String) {
    
        profileImage.loadProfilePostImage(url: imgUrl)
        profileImage.encircled()
        nameLabel.text = username.isEmpty ? K.String.User.Anonymous.localized : username
        statusLabel.text = status
    }
}
