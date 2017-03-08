//
//  Util.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/1/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class Util: NSObject {

    class func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName )
            print("Font Names = [\(names)]")
        }
    }
    
    class func controllerFromStoryboard( id:String ) -> LocalityBaseViewController {
        let storyboard = UIStoryboard(name: K.Storyboard.Name.Main, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: id) as! LocalityBaseViewController
    }
    
    class func getPList(name:String) -> [String: AnyObject] {
        
        if let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            
            return dict
        }
            
        else {
            
            return [:]
        }
    }
    
    //Location Slider Utility
    class func attributedRangeString(value:String, unit:String) -> NSMutableAttributedString {
        
        let rawString = NSString(format: "%@%@", value, unit)
        let attrString:NSMutableAttributedString = NSMutableAttributedString(string: rawString as String)
        
        let font = UIFont(name: K.FontName.InterstateLightCondensed, size: 19)
        let smallFont = UIFont(name: K.FontName.InterstateLightCondensed, size: 13)
        
        attrString.beginEditing()
        attrString.addAttribute(NSFontAttributeName,
                                value: font!,
                                range: NSMakeRange(0, value.characters.count))
        attrString.addAttribute(NSFontAttributeName,
                                value: smallFont!,
                                range: NSMakeRange(value.characters.count, unit.characters.count))
        attrString.addAttribute(NSBaselineOffsetAttributeName,
                                value: 4,
                                range: NSMakeRange(value.characters.count, unit.characters.count))
        attrString.endEditing()
        
        return attrString
    }
    
    class func metersToFeet(meters:CGFloat) -> CGFloat {
        return meters * 3.28084
    }
    
    class func feetToMeters(feet:CGFloat) -> CGFloat {
        return feet * 0.3408
    }
}
