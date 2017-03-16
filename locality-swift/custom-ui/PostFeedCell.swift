//
//  PostFeedCell.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Mapbox

class PostFeedCell: UITableViewCell {

    var postImage:UIImageView!
    var postContent:PostFeedCellView!
    
    var thisModel:UserPost!
    var hasImage:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    convenience init(model:UserPost) {
        self.init()
        
        thisModel = model
        hasImage = !thisModel.postImageUrl.isEmpty
        
        initImage()
        initCellViewContent()
        
        let imgHeight = hasImage == true ? (K.Screen.Width * K.NumberConstant.Post.ImageRatio) : 0
        let cellHeight:CGFloat = postContent.frame.size.height + imgHeight
        
        frame = CGRect(origin: CGPoint.zero, size: CGSize(width: K.Screen.Width, height: cellHeight))
        
        if hasImage == true {
            addSubview(postImage)
        }
        addSubview(postContent)
        
        
    }
    
    convenience init(model:UserPost, proximityTo:CLLocationCoordinate2D) {
        self.init(model:model)
        
        let origin:CLLocation = CLLocation(latitude: proximityTo.latitude, longitude: proximityTo.longitude)
        let here:CLLocation = CLLocation(latitude:model.lat, longitude:model.lon)
        let distance:CLLocationDistance = here.distance(from: origin)
        
        let fromData:RangeStep = Util.distanceToDisplay(distance: CGFloat(distance))
        
        postContent.filterView.filterLabel.attributedText = Util.attributedDistanceFromString(value:fromData.distance.description, unit: fromData.unit)
    }
    
    func initImage() {
        
        if hasImage == false {
            return
        }
        
        postImage = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: K.Screen.Width, height: K.Screen.Width * K.NumberConstant.Post.ImageRatio)))
        
        postImage.loadPostImage(url: thisModel.postImageUrl)
    }
    
    func initCellViewContent() {
        let postY:CGFloat = hasImage == true ? postImage.frame.size.height : 0
        
        postContent = UIView.instanceFromNib(name: K.NIBName.PostFeedCellView) as! PostFeedCellView
        postContent.frame = CGRect(x: 0, y: postY, width: K.Screen.Width, height: postContent.getViewHeight(caption: thisModel.caption))
        
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
    }
    
    func populateUserInfo() {
        postContent.postUser.populate(imgUrl: thisModel.user.profileImageUrl,
                                      username: thisModel.user.username,
                                      status: UserStatus.stringFrom(type: thisModel.user.status))

    }
}
