//
//  PostSortView.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Mapbox
import NSDate_TimeAgo

class PostSortView: UIView {
    
    @IBOutlet weak var sortLabel:UILabel!
    @IBOutlet weak var sortIcon:UIImageView!
    @IBOutlet weak var sortLabelWidth:NSLayoutConstraint!

    var thisPost:UserPost!
    
    func populate(model:UserPost) {
        
        thisPost = model
        
        switch CurrentUser.shared.sortByType {
        case .proximity:
            showSortProximity()
            break
            
        case .time:
            showSortTime()
            break
            
        case .activity:
            showSortActivity()
            break
        }
        
        sortIcon.image = setIcon()
        sizeSortLabel()
    }
    
    func showSortProximity() {

        let distance = Util.distanceFrom(lat:thisPost.lat, lon:thisPost.lon)
        let fromData:RangeStep = Util.distanceToDisplay(distance: CGFloat(distance))
        let correctedDistance:String = fromData.distance.description.replacingOccurrences(of: ".0", with: "")
        
        sortLabel.attributedText = Util.attributedDistanceFromString(value:correctedDistance,
                                                                     unit: fromData.unit)
    }
    
    func showSortTime() {
        let date:NSDate = thisPost.createdDate as NSDate
        sortLabel.text = date.timeAgo()
    }
    
    func showSortActivity() {
        sortLabel.text = thisPost.commentCount.description
    }
    
    func setIcon() -> UIImage {
        switch CurrentUser.shared.sortByType {
        case .proximity:
            return UIImage(named:K.Icon.Sort.Proximity)!
            
        case .time:
            return UIImage(named:K.Icon.Sort.Time)!
            
        case .activity:
            return UIImage(named:K.Icon.Sort.Activity)!
        }
    }
    
    func sizeSortLabel() {
        let sizedWidth = sortLabel.intrinsicContentSize.width
        sortLabelWidth.constant = sizedWidth
        
        sortLabel.setNeedsUpdateConstraints()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
