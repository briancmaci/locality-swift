//
//  CommentFeedCell.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/14/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class CommentFeedCell: UITableViewCell {

    @IBOutlet weak var postUser:PostUserInfoView!
    @IBOutlet weak var commentText:UILabel!
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
    
    convenience init(comment:UserComment) {
        self.init()
        
        thisComment = comment
        backgroundColor = K.Color.commentBackground
        populateWithData()
        
    }

    func populateWithData() {
    
        postUser.populate(imgUrl: thisComment.user.profileImageUrl,
                          username: thisComment.user.username,
                          status: UserStatus.stringFrom(type: thisComment.user.status))
        
        commentText.text = thisComment.commentText
    }

    func getViewHeight(txt:String) -> CGFloat {
        return K.NumberConstant.Comment.DefaultHeight - K.NumberConstant.Comment.DefaultCommentHeight + commentText.requiredHeight()
    }
    
    func popBackground() {
        backgroundColor = .white
    }
}
