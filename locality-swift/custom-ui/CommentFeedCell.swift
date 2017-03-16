//
//  CommentFeedCell.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/14/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import NSDate_TimeAgo

class CommentFeedCell: UITableViewCell {

    @IBOutlet weak var postUser:PostUserInfoView!
    @IBOutlet weak var commentText:UILabel!
    @IBOutlet weak var timeAgoLabel:UILabel!
    @IBOutlet weak var pinline:UIView!
    
    var thisComment:UserComment!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCellViewContent(comment:UserComment) {
        
        thisComment = comment
        commentText.text = thisComment.commentText
        
        backgroundColor = K.Color.commentBackground
        
        let date:NSDate = thisComment.createdDate as NSDate
        timeAgoLabel.text = date.timeAgo()
        
        populateWithUser()
    }
    
    func populateWithUser() {
    
        postUser.populate(imgUrl: thisComment.user.profileImageUrl,
                          username: thisComment.user.username,
                          status: UserStatus.stringFrom(type: thisComment.user.status))
    }

    func getViewHeight(txt:String) -> CGFloat {
        commentText.text = txt
        return K.NumberConstant.Comment.DefaultHeight - K.NumberConstant.Comment.DefaultCommentHeight + commentText.requiredHeight()
    }
    
    func popBackground() {
        backgroundColor = .white
    }
}
