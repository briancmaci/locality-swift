//
//  PostFeedCellView.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

protocol CommentButtonDelegate {
    func commentButtonTouched()
}

class PostFeedCellView: UIView {

    @IBOutlet weak var view:UIView!
    
    @IBOutlet weak var postUser:PostUserInfoView!
    @IBOutlet weak var captionLabel:UILabel!
    @IBOutlet weak var likeButton:LikePostButton!
    @IBOutlet weak var commentButton:CommentButton!
    @IBOutlet weak var sortView:PostSortView!
    @IBOutlet weak var pinline:UIView!
    
    var thisPost:UserPost!
    var delegate:CommentButtonDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed(K.NIBName.PostFeedCellView, owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    
    func populate(model:UserPost) {
        thisPost = model
        
        initButtons()
        populateSortView()
    }
    
    func initButtons() {
        likeButton.addTarget(self, action: #selector(likeDidTouch), for: .touchUpInside)
        likeButton.isSelected = thisPost.isLikedByMe
        
        commentButton.addTarget(self, action: #selector(commentDidTouch), for: .touchUpInside)
        
        if thisPost.commentCount > 0 {
            commentButton.setTitle(thisPost.commentCount.description, for: .normal)
            commentButton.hasComments(true)
        } else {
            commentButton.setTitle("", for: .normal)
            commentButton.hasComments(false)
        }
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
    
    func commentDidTouch(sender:CommentButton) {
        delegate?.commentButtonTouched()
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
        captionLabel.text = caption
        return K.NumberConstant.Post.DefaultViewHeight - K.NumberConstant.Post.DefaultCaptionHeight + captionLabel.requiredHeight()
    }
}
