//
//  Util.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/1/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import GoogleMaps

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
    
    class func locationLabel(address:GMSAddress) -> String {
        var address0:String!
        var address1:String!

        if let tryAdd0 = address.locality {
            address0 = tryAdd0
        }
        else if let tryAdd0 = address.subLocality {
            address0 = tryAdd0
        }
        else {
            address0 = ""
        }
        
        if let tryAdd1 = address.administrativeArea {
            address1 = tryAdd1
        }
        else if let tryAdd1 = address.country {
            address1 = tryAdd1
        }
        else {
            address1 = ""
        }
        
        if address0.isEmpty && address1.isEmpty {
            return "Unknown"
        }
        
        else if !address0.isEmpty && address1.isEmpty {
            return address0
        }
        
        else if address0.isEmpty && !address1.isEmpty {
            
            //test what we have here thus far
            if address.administrativeArea != nil {
                address0 = address.administrativeArea
                address1 = address.country
                
                return String(format:"%@, %@", address0, address1)
            }
            
            else {
                return address1
            }
        }
        
        else {
            return String(format:"%@, %@", address0, address1)
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
        let smallFont = UIFont(name: K.FontName.InterstateLightCondensed, size: 10)
        
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
                unit = "km"
            }
            
            else {
                unit = "m"
            }
        }
        
        else if CurrentUser.shared.isMetric == false {
            if convertedDistance > imperialThreshold {
                convertedDistance = convertedDistance / imperialThreshold
                unit = "mi"
            }
            
            else {
                unit = "ft"
            }
        }
        
        return RangeStep(distance: convertedDistance.roundTo(places: 1), label: "", unit: unit)
    }
    
    class func distanceFrom(lat:Double, lon:Double) -> Double {
        let origin:CLLocation = CLLocation(latitude: CurrentUser.shared.myLastRecordedLocation.latitude,
                                           longitude: CurrentUser.shared.myLastRecordedLocation.longitude)
        
        let here:CLLocation = CLLocation(latitude:lat, longitude:lon)
        return here.distance(from: origin)
    }
    
    class func displayUsername(post:UserPost) -> String {
        
        if post.isAnonymous == true {
            return K.String.User.Anonymous.localized
        }
            
        else if post.user.uid == CurrentUser.shared.uid {
            return K.String.User.Me.localized
        }
        
        else {
            return post.user.username
        }
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
    
    class func intFromDate(date:Date) -> Int {
        return Int(date.timeIntervalSince1970)
    }
    
    class func dateFromInt(dateInt:Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(dateInt))
    }
}
