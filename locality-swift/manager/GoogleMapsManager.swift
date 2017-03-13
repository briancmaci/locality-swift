//
//  GoogleMapsManager.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/13/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GoogleMapsManager: NSObject {
    
    class func initGoogleMaps() {
        let apiKey:String = Util.getPList(name: K.PList.Keys)[K.APIKey.GooglePlaces] as! String
        GMSServices.provideAPIKey(apiKey)
        GMSPlacesClient.provideAPIKey(apiKey)
    }
    
    class func reverseGeocode(coord:CLLocationCoordinate2D, completionHandler: @escaping (GMSAddress?, Error?) -> ()) -> () {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coord) { (response, error) in
            let address:GMSAddress = (response?.firstResult())!
            
            if error != nil {
                print("GMSReverseGeocode Error: \(error?.localizedDescription)")
                completionHandler(nil, error)
            }
            
            else {
                //print("ADDRESS?? \(address)")
                completionHandler(address, nil)
            }
        }
    }
        
}
