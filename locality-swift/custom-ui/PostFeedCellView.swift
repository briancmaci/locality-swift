//
//  PostFeedCellView.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class PostFeedCellView: UIView {

    let kDefaultHeight:CGFloat = 166.0
    let kDefaultCaptionHeight:CGFloat = 32.0
    
    @IBOutlet weak var postUser:PostUserInfoView!
    @IBOutlet weak var captionLabel:UILabel!
    @IBOutlet weak var likeButton:LikePostButton!
    @IBOutlet weak var commentButton:CommentButton!
    @IBOutlet weak var filterView:PostFilterView!
    @IBOutlet weak var pinline:UIView!
    
    var thisPost:UserPost!
    
    func populate(model:UserPost) {
        thisPost = model
    }
    
    func getViewHeight(caption:String) -> CGFloat {
        return kDefaultHeight - kDefaultCaptionHeight + captionLabel.requiredHeight()
    }
}
