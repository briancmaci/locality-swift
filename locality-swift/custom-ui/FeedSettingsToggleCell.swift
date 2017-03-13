//
//  FeedSettingsToggleCell.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/12/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class FeedSettingsToggleCell: UITableViewCell {

    @IBOutlet weak var settingsLabel:UILabel!
    @IBOutlet weak var settingsSwitch:UISwitch!
    
    var data:[String:AnyObject]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initStage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initStage() {
        settingsSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    
    func populate(data:[String:AnyObject]){
        self.data = data
        
        settingsLabel.text = (data["label"] as! String).localized
        settingsSwitch.setOn(data["default"] as! Bool, animated: false)
    }
}
