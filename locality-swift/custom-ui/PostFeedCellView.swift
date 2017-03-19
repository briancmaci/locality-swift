//
//  PostFeedCellView.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class PostFeedCellView: UIView {

    @IBOutlet weak var postUser:PostUserInfoView!
    @IBOutlet weak var captionLabel:UILabel!
    @IBOutlet weak var likeButton:LikePostButton!
    @IBOutlet weak var commentButton:CommentButton!
    @IBOutlet weak var sortView:PostSortView!
    @IBOutlet weak var pinline:UIView!
    
    var thisPost:UserPost!
    
    func populate(model:UserPost) {
        thisPost = model
        
        initButtons()
        populateSortView()
    }
    
    func initButtons() {
        likeButton.addTarget(self, action: #selector(likeDidTouch), for: .touchUpInside)
        likeButton.isSelected = thisPost.isLikedByMe
        
        commentButton.setTitle(thisPost.commentCount.description, for: .normal)
    }
    
    //CTA
    
    func likeDidTouch(sender:LikePostButton) {
        
        if likeButton.isSelected == true {
            likeButton.isSelected = !likeButton.isSelected
            unlikePost()
        }
        
        else {
            likeButton.isSelected = !likeButton.isSelected
            likePost()
        }
    }
    
    //Like Methods
    func likePost() {
        FirebaseManager.likePost(pid: thisPost.postId) { (likes, error) in
            
            if error == nil {
                
                //update current user
                self.thisPost.likedBy = likes!
                self.thisPost.isLikedByMe = true
            }
            
            else {
                print("Error liking: \(error?.localizedDescription)")
                self.likeButton.isSelected = false
            }
        }
        
    }
    
    func unlikePost() {
        FirebaseManager.unlikePost(pid: thisPost.postId) { (likes, error) in
            
            if error == nil {
                self.thisPost.likedBy = likes!
                self.thisPost.isLikedByMe = false
            }
            
            else {
                print("Error unliking: \(error?.localizedDescription)")
                self.likeButton.isSelected  = true
            }
        }
    }
    
    func populateSortView() {
        sortView.populate(model:thisPost)
    }
    
    func getViewHeight(caption:String) -> CGFloat {
        return K.NumberConstant.Post.DefaultViewHeight - K.NumberConstant.Post.DefaultCaptionHeight + captionLabel.requiredHeight()
    }
    
    
    
    
    
}
