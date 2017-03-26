//
//  CommentButton.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class CommentButton: UIButton {

    override func draw(_ rect: CGRect) {
        
        layer.cornerRadius = frame.size.height/2
        layer.borderColor = K.Color.localityBlue.cgColor
        layer.borderWidth = 1.0
        
        clipsToBounds = true
    }
    
    func hasComments(_ val:Bool) {
        if val == true {
            backgroundColor = K.Color.localityBlue
            setTitleColor(.white, for: .normal)
            setImage(UIImage(named:K.Icon.Post.PostCommentIconWhite), for: .normal)
            tintColor = .white
        }
        
        else {
            backgroundColor = .white
            setTitleColor(K.Color.postCommentGray, for: .normal)
            setImage(UIImage(named:K.Icon.Post.PostCommentIconGray), for: .normal)
        }
    }
}
