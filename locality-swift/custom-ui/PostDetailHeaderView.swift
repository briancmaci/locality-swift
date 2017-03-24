//
//  PostDetailHeaderView.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/14/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class PostDetailHeaderView: UIView {

    @IBOutlet weak var view:UIView!
    
    @IBOutlet weak var drawingBackground:PostDetailHeaderBackground!
    @IBOutlet weak var userInfo:PostUserInfoView!
    @IBOutlet weak var sortView:PostSortView!
    @IBOutlet weak var captionLabel:UILabel!
    
    var thisPost:UserPost!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed(K.NIBName.PostDetailHeaderView, owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    func getViewHeight(caption:String) -> CGFloat {
        return K.NumberConstant.Post.DefaultHeaderViewHeight - K.NumberConstant.Post.DefaultHeaderCaptionHeight + captionLabel.requiredHeight()
    }
    
    func populateWithData(model:UserPost) {
        thisPost = model
        
        userInfo.populate(imgUrl: thisPost.isAnonymous ? K.Image.DefaultAvatarProfilePost : thisPost.user.profileImageUrl,
                          username: Util.displayUsername(post: thisPost),
                          status: UserStatus.stringFrom(type: thisPost.user.status))
        
        captionLabel.text = thisPost.caption
        
        sortView.populate(model: thisPost)
    }
}
