//
//  DataParseManager.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/5/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class DataParseManager: NSObject {

    class func parseReverseGeoData(data:Any?) -> String {
        
        //var placeName:String?
        //var returnString:String = ""
        
        let dataDictionary = data as! Dictionary<String, AnyObject>
        let results = dataDictionary["features"] as! [AnyObject]
        
        print("results? \(results)")
        
        if let rawPlaceName = results[0].object(forKey: "place_name") as? String {
            
            //remove United States
            let placeName = (rawPlaceName as NSString).replacingOccurrences(of: ", United States", with: "")
            return placeName
        }
        
        
        
//        let rawPlaceName = results.object(forKey:"place_name") as! String
//        
//        
//        if let placeNameObject = results["place_name"] as! String {
//            
//            returnString = placeNameObject
//        }
//        
//        else {
//            return returnString
//        }
        
        return ""
    }
}
