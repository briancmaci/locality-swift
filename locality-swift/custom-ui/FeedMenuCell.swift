//
//  FeedMenuCell.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/12/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class FeedMenuCell: UITableViewCell {

    @IBOutlet weak var heroView:FlexibleFeedHeaderView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(feed:FeedLocation) {
        heroView.populate(model: feed, index: 0, inFeedMenu: true)
    }
    
}
