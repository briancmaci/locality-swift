//
//  GeoFireManager.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/10/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Firebase
import GeoFire

class GeoFireManager: NSObject {

    class func write(postLocation:CLLocation, postId:String, completionHandler: @escaping (Bool?, Error?) -> ()) -> () {
        
       let geofire = getGeofireLocationsRef()
        
        geofire.setLocation(postLocation, forKey: postId) { (error) in
            if (error != nil) {
                completionHandler(false, error)
            } else {
                completionHandler(true, nil)
            }
        }
    }
    
    class func delete(postId:String, completionHandler: @escaping(Error?) -> ()) -> () {
        let geofire = getGeofireLocationsRef()
        
        geofire.removeKey(postId) { (error) in
            completionHandler(error)
        }
    }
    
    class func getPostLocations(range:Float, location:CLLocation, completionHandler: @escaping ([String]?, Error?) -> ()) -> () {
        var matchingPosts:[String] = [String]()
        
        let geofire = getGeofireLocationsRef()
        let radiusInKM = (range/2)/1000
        
        let query = geofire.query(at: location, withRadius: Double(radiusInKM))
        
        query?.observe(.keyEntered, with: { (key, location) in
            matchingPosts.append(key!)
        })
        
        query?.observeReady({
            completionHandler(matchingPosts, nil)
        })
    }
    
    class func getGeofireLocationsRef() -> GeoFire {
        
        let dbID = Util.getPList(name: K.PList.Keys)[K.APIKey.Firebase] as! String
        let firURL = String(format:K.DB.FirebaseURLFormat, dbID)
        let geofireRef = FIRDatabase.database().reference(fromURL: firURL)
        
        return GeoFire(firebaseRef: geofireRef.child(K.DB.Table.PostLocations))
    }
}
