//
//  MapboxManager.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/4/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Mapbox

class MapboxManager: NSObject {
    
    class func initMapbox() {
        let accessToken = Util.getPList(name:K.PList.Keys)[K.APIKey.Mapbox] as! String
        MGLAccountManager.setAccessToken(accessToken)
    }
    
    //Range Circle Utility
    class func polygonCircleForCoordinate(coordinate:CLLocationCoordinate2D, meterRadius:Double) -> MGLPolygon {
        let pointSeparation:CGFloat = 8
        let pointCount:Int = Int(floor(360 / pointSeparation))
        let distanceRad = meterRadius / K.NumberConstant.Map.EarthRadius
        let centerRadLat:Double = coordinate.latitude * M_PI / 180
        let centerRadLong:Double = coordinate.longitude * M_PI / 180
        
        var coordinates:[CLLocationCoordinate2D] = []
        
        for i in 0...pointCount {
            let degrees:Double = Double(Int(pointSeparation) * i)
            let degreeRad:Double = degrees * M_PI / 180
            
            let pointRadLat:Double = asin( sin(centerRadLat) * cos(distanceRad) + cos(centerRadLat) * sin(distanceRad) * cos(degreeRad))
            let pointRadLong:Double = centerRadLong + atan2( sin(degreeRad) * sin(distanceRad) * cos(centerRadLat),
                                                             cos(distanceRad) - sin(centerRadLat) * sin(pointRadLat))
            
            let pointLat:Double = pointRadLat * 180 / M_PI
            let pointLong:Double = pointRadLong * 180 / M_PI
            
            let point:CLLocationCoordinate2D = CLLocationCoordinate2DMake(pointLat, pointLong)
            coordinates.append(point)
        }
        
        return MGLPolygon(coordinates: coordinates, count: UInt(pointCount))
        
    }
    
    class func metersToDegrees(coord:CLLocationCoordinate2D, metersLat:Double, metersLong:Double) -> CLLocationCoordinate2D {
        
        //Get distance in radians
        let deltaLat:Double = metersLat/K.NumberConstant.Map.EarthRadius
        let deltaLong:Double = metersLong/K.NumberConstant.Map.EarthRadius
        
        let newLat:Double = coord.latitude + deltaLat * 180/M_PI
        let newLong:Double = coord.longitude + deltaLong * 180/M_PI
        
        return CLLocationCoordinate2D(latitude: newLat, longitude: newLong)
    }
}
