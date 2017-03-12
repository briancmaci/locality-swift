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
    
    class func controllerFromStoryboard( id:String ) -> UIViewController {
        let storyboard = UIStoryboard(name: K.Storyboard.Name.Main, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: id) 
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
    
    class func getPListArray(name:String) -> [[String: AnyObject]] {
        
        if let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let dict = NSArray(contentsOfFile: path) as? [[String: AnyObject]] {
            
            return dict
        }
            
        else {
            
            return [[:]]
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
    
    class func attributedDistanceFromString(value:String, unit:String) -> NSMutableAttributedString {
        
        let rawString = NSString(format: "%@ %@", value, unit)
        let attrString:NSMutableAttributedString = NSMutableAttributedString(string: rawString as String)
        
        let font = UIFont(name: K.FontName.InterstateLightCondensed, size: 13)
        let smallFont = UIFont(name: K.FontName.InterstateLightCondensed, size: 9)
        
        attrString.beginEditing()
        attrString.addAttribute(NSFontAttributeName,
                                value: font!,
                                range: NSMakeRange(0, value.characters.count))
        attrString.addAttribute(NSFontAttributeName,
                                value: smallFont!,
                                range: NSMakeRange(value.characters.count, unit.characters.count+1))
        attrString.addAttribute(NSBaselineOffsetAttributeName,
                                value: 3,
                                range: NSMakeRange(value.characters.count, unit.characters.count+1))
        attrString.endEditing()
        
        return attrString
    }
    
    //Translate distanceFrom to prettyPrint format
    class func distanceToDisplay(distance:CGFloat) -> RangeStep {
        var unit:String!
        
        let metricThreshold:CGFloat = 1000 //change to KM
        let imperialThreshold:CGFloat = 5280 //change to MI
        
        var convertedDistance = CurrentUser.shared.isMetric ? distance : metersToFeet(meters: distance)
        
        if CurrentUser.shared.isMetric == true {
            if convertedDistance > metricThreshold {
                convertedDistance = convertedDistance / metricThreshold
                unit = "KM"
            }
            
            else {
                unit = "M"
            }
        }
        
        else if CurrentUser.shared.isMetric == false {
            if convertedDistance > imperialThreshold {
                convertedDistance = convertedDistance / imperialThreshold
                unit = "MI"
            }
            
            else {
                unit = "FT"
            }
        }
        
        return RangeStep(distance: convertedDistance.roundTo(places: 1), label: "", unit: unit)
    }
    
    class func generateUUID() -> String {
        return UUID().uuidString
    }
    
    class func metersToFeet(meters:CGFloat) -> CGFloat {
        return meters * 3.28084
    }
    
    class func feetToMeters(feet:CGFloat) -> CGFloat {
        return feet * 0.3408
    }
    
    class func stringFromDate(date:Date) -> String {
        
        let format:DateFormatter = DateFormatter()
        format.setLocalizedDateFormatFromTemplate(K.String.Post.TimestampFormat)
        
        return format.string(from: date)
        
    }
    
    class func dateFromString(dateStr:String) -> Date {
    
        let format:DateFormatter = DateFormatter()
        format.setLocalizedDateFormatFromTemplate(K.String.Post.TimestampFormat)
        
        return format.date(from: dateStr)!
    }
}
