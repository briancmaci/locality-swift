//
//  UILabelExtension.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import Foundation

extension UILabel {
    
    func requiredHeight() -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRect(x:0, y:0, width:self.frame.width, height:CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            style.alignment = .center
            
            attributeString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, text.characters.count))
            
            
            self.attributedText = attributeString
        }
    }
}
