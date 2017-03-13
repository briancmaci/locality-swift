//
//  FeedAddNewCell.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/12/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class FeedAddNewCell: UITableViewCell {

    @IBOutlet weak var label:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        label.text = K.String.Feed.AddFeedLabel.localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
