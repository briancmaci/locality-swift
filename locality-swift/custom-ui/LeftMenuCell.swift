//
//  LeftMenuCell.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/11/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class LeftMenuCell: UITableViewCell {
    
    @IBOutlet weak var optionLabel:UILabel!
    @IBOutlet weak var pinline:UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        buildSelectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func buildSelectionView() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = K.Color.leftNavSelected
        selectedBackgroundView = bgColorView
    }
    
}
