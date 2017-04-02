//
//  UIImageViewExtension.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import Foundation

extension UIImageView {
    
    func encircled() {
        layer.cornerRadius = frame.size.height/2
        layer.masksToBounds = true
    }
    
    func loadProfileImage(url:String) {
        
        if url == K.Image.DefaultAvatarProfile {
            image = UIImage(named:K.Image.DefaultAvatarProfile)
            return
        }
        
        sd_setImage(with: URL(string:url)) { (image, error, cacheType, imgURL) in
            if (cacheType == .disk || cacheType == .none) {
                self.alpha = 0
                UIView.animate(withDuration: 0.25, animations: { 
                    self.alpha = 1
                })
            }
            
            else {
                self.alpha = 1
            }
        }
    }
    
    func loadProfilePostImage(url:String) {
        
        if url == K.Image.DefaultAvatarProfilePost {
            image = UIImage(named:K.Image.DefaultAvatarProfilePost)
            return
        }
        
        sd_setImage(with: URL(string:url)) { (image, error, cacheType, imgURL) in
            if cacheType == .none || cacheType == .disk {
                self.alpha = 0
                UIView.animate(withDuration: 0.25, animations: {
                    self.alpha = 1
                })
            }
                
            else {
                self.alpha = 1
            }
        }
    }
    
    func loadPostImage(url:String) {
        
        sd_setImage(with: URL(string:url)) { (image, error, cacheType, imgURL) in
            
            if cacheType == .none || cacheType == .disk {
                self.alpha = 0
                UIView.animate(withDuration: 0.4, animations: {
                    self.alpha = 1
                })
            }
        }
    }
}
