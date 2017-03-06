//
//  AFNetworkingManager.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/4/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

import UIKit
import AFNetworking
import Mapbox

class AFNetworkingManager: NSObject {
    
    static let manager : AFHTTPSessionManager = AFHTTPSessionManager()
    
    // getReverseGeocode Data
    class func getReverseGeocodingFor(coordinate:CLLocationCoordinate2D, completionHandler: @escaping (Any?, Error?) -> ()) -> () {
        
        manager.responseSerializer.acceptableContentTypes = Set(["application/vnd.geo+json", "application/json"])
        
        let apiKey = AppUtilities.getPListDictionary(name: K.PList.Keys)[K.APIKey.Mapbox] as! String
        let rawURLString = String(format:K.BackEndURL.ReverseGeocodeFormat, coordinate.longitude, coordinate.latitude, apiKey)
        
        let encodedString = rawURLString.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)

        manager.get(encodedString!,
                    parameters: nil,
                    progress: nil,
                    success: {
                        (task: URLSessionDataTask?, responseObject: Any?) in
                        completionHandler(responseObject, nil)
        },
                    failure: {
                        (task: URLSessionDataTask?, error: Error) in
                        completionHandler(nil, error)
        }
        )
        
        
    }
}
