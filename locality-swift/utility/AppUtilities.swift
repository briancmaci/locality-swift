//
//  AppUtilities.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/1/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class AppUtilities: NSObject {

    class func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName )
            print("Font Names = [\(names)]")
        }
    }
    
    class func getViewControllerFromStoryboard( id:String ) -> LocalityBaseViewController {
        let storyboard = UIStoryboard(name: K.Storyboard.Name.Main, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: id) as! LocalityBaseViewController
    }
    
    class func getPListDictionary(name:String) -> [String: AnyObject] {
        
        if let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            
            return dict
        }
            
        else {
            
            return [:]
        }
    }
    
    class func metersToFeet(meters:CGFloat) -> CGFloat {
        return meters * 3.28084
    }
    
    class func feetToMeters(feet:CGFloat) -> CGFloat {
        return feet * 0.3408
    }
}
