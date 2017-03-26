//
//  FeedLocation.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/8/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Mapbox

class FeedLocation: NSObject {

    var locationId:String
    
    var name:String
    var location:String
    var feedImgUrl:String
    
    var lat:Double
    var lon:Double
    var range:Float

    var isCurrentLocation:Bool = false
    
    var promotionsEnabled:Bool = true
    var pushEnabled:Bool = false
    var importantEnabled:Bool = true
    
    init(coord:CLLocationCoordinate2D, name:String) {
        
        self.locationId = Util.generateUUID()
        
        self.lat = coord.latitude
        self.lon = coord.longitude
        self.name = name
        
        self.location = ""
        self.feedImgUrl = K.Image.DefaultFeedHero
        
        self.range = Float(K.NumberConstant.Map.DefaultRange)
    }
    
    init(firebaseDictionary:[String:AnyObject]) {
        
        self.name = firebaseDictionary[K.DB.Var.Name] as! String
        self.location = firebaseDictionary[K.DB.Var.Location] as! String
        
        if firebaseDictionary[K.DB.Var.LocationId] != nil {
            self.locationId = firebaseDictionary[K.DB.Var.LocationId] as! String
        } else {
            self.locationId = Util.generateUUID()
        }
        
        self.feedImgUrl = firebaseDictionary[K.DB.Var.FeedImgURL] as! String
        self.lat = firebaseDictionary[K.DB.Var.Lat] as! Double
        self.lon = firebaseDictionary[K.DB.Var.Lon] as! Double
        self.range = firebaseDictionary[K.DB.Var.Range] as! Float
        self.isCurrentLocation = firebaseDictionary[K.DB.Var.IsCurrentLocation] as! Bool
        self.promotionsEnabled = firebaseDictionary[K.DB.Var.PromotionsEnabled] as! Bool
        self.pushEnabled = firebaseDictionary[K.DB.Var.PushEnabled] as! Bool
        self.importantEnabled = firebaseDictionary[K.DB.Var.ImportantEnabled] as! Bool
    }
    
    convenience init(coord:CLLocationCoordinate2D, name:String, range:Float, current:Bool) {
        
        self.init(coord:coord, name:name)
        self.range = range
        self.isCurrentLocation = current
    }
    
    func toFireBaseObject() -> [String:Any] {
        
        return [K.DB.Var.Name : name,
                K.DB.Var.Location : location,
                K.DB.Var.LocationId : locationId,
                K.DB.Var.FeedImgURL : feedImgUrl,
                K.DB.Var.Lat : lat,
                K.DB.Var.Lon : lon,
                K.DB.Var.Range : range,
                K.DB.Var.IsCurrentLocation : isCurrentLocation,
                K.DB.Var.PromotionsEnabled : promotionsEnabled,
                K.DB.Var.PushEnabled : pushEnabled,
                K.DB.Var.ImportantEnabled : importantEnabled]
    }
}
