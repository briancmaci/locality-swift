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

    var name:String
    var location:String
    var feedImgUrl:String
    
    var lat:Double
    var lon:Double
    var range:Float

    var isCurrentLocation:Bool = false
    
    var promotionsEnabled:Bool = true
    var pushEnabled:Bool = true
    var importantEnabled:Bool = true
    
    init(coord:CLLocationCoordinate2D, name:String) {
        
        self.lat = coord.latitude
        self.lon = coord.longitude
        self.name = name
        
        self.location = ""
        self.feedImgUrl = K.Image.DefaultFeedHero
        
        self.range = Float(K.NumberConstant.Map.DefaultRange)
    }
    
    convenience init(coord:CLLocationCoordinate2D, name:String, range:Float, current:Bool) {
        
        self.init(coord:coord, name:name)
        self.range = range
        self.isCurrentLocation = current
    }
    
    func toFireBaseObject() -> [String:Any] {
        
        return [K.DB.Var.Name : name,
                K.DB.Var.Location : location,
                K.DB.Var.FeedImgURL : feedImgUrl,
                K.DB.Var.Lat : lat,
                K.DB.Var.Lon : lon,
                K.DB.Var.Range : range,
                K.DB.Var.IsCurrentLocation : isCurrentLocation,
                K.DB.Var.PromitionsEnabled : promotionsEnabled,
                K.DB.Var.PushEnabled : pushEnabled,
                K.DB.Var.ImportantEnabled : importantEnabled]
    }
}
