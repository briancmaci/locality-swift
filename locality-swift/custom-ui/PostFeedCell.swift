//
//  PostFeedCell.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Mapbox
import SWTableViewCell

protocol PostFeedCellDelegate {
    func gotoPost(post:UserPost)
}

class PostFeedCell: SWTableViewCell, CommentButtonDelegate {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postImageBackground: UIView!
    @IBOutlet weak var postContent: PostFeedCellView!
    @IBOutlet weak var postImageHeight: NSLayoutConstraint!
    
    var thisModel:UserPost!
    var hasImage:Bool = false
    var postDelegate:PostFeedCellDelegate?
    
    func populate(model:UserPost) {
        
        //remove image always
        postImage.image = nil
        
        thisModel = model
        hasImage = !thisModel.postImageUrl.isEmpty
        
        setStage()
    }
    
    func setStage() {
        initImage()
        initCellViewContent()
    }
    
    func initImage() {
        
        if hasImage == false {
            postImageHeight.constant = 0.0
            postImageBackground.backgroundColor = .white
            postImage.backgroundColor = .white
            postImage.layoutIfNeeded()
            return
        }
        
        postImageHeight.constant = K.Screen.Width * K.NumberConstant.Post.ImageRatio
        postImage.setNeedsLayout()
        postImage.backgroundColor = .clear
        postImageBackground.backgroundColor = UIColor(hex: thisModel.averageColorHex)
        postImage.loadPostImage(url: thisModel.postImageUrl)
    }
    
    func initCellViewContent() {
        postContent.captionLabel.text = thisModel.caption
        postContent.populate(model: self.thisModel)
        
        //Load user from UserHandle
        FirebaseManager.getUserFromHandle(uid: thisModel.userHandle) { (thisUser) in
            
            if thisUser == nil {
                print("User no longer exists")
                return
            }
            
            self.thisModel.user = thisUser!
            self.populateUserInfo()
        }
        
        postContent.delegate = self
    }
    
    func populateUserInfo() {
        
        postContent.postUser.populate(imgUrl: thisModel.isAnonymous ? K.Image.DefaultAvatarProfilePost : thisModel.user.profileImageUrl,
                                      username: Util.displayUsername(post: thisModel),
                                      status: UserStatus.stringFrom(type: thisModel.user.status))
    }
    
    func commentButtonTouched() {
        postDelegate?.gotoPost(post: thisModel)
    }
}
