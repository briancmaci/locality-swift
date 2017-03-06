//
//  CurrentFeedInitializeViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/4/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Mapbox

class CurrentFeedInitializeViewController: LocalityBaseViewController, MGLMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map : MGLMapView!
    @IBOutlet weak var locationHeaderLabel : UILabel!
    @IBOutlet weak var locationLabel : UILabel!
    
    var locationManager:CLLocationManager!
    var currentLocation:CLLocationCoordinate2D!
    
    var currentRadiusIndex:Int!
    var sliderSteps:[RangeStep]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initRangeSlider()
        initMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initRangeSlider() {
        
        sliderSteps = [RangeStep]()
        
        let stepsArray = AppUtilities.getPListDictionary(name: K.PList.RangeValuesFeet)["Steps"] as! [AnyObject]
        
        for i in 0...stepsArray.count-1 {
            
            let step:RangeStep = RangeStep(distance: stepsArray[i]["distance"] as! CGFloat,
                                           label:stepsArray[i]["label"] as! String,
                                           unit:stepsArray[i]["unit"] as! String)
            
            print("STEP MADE! \(step.distance, step.label, step.unit)")
            
            sliderSteps.append(step)
        }
    }
    
    func initMap() {
        
        //Start polling
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
        
        map.showsUserLocation = false
        
        //init light style
        let localityStyleURL = K.Mapbox.MapStyle
        map.styleURL = URL(string:localityStyleURL)
        
        map.delegate = self
    }
    
    func initMapRange() {
        
        map.centerCoordinate = currentLocation
        
        let rangePointSW:CLLocationCoordinate2D = MapboxManager.metersToDegrees(coord: map.centerCoordinate, metersLat: -500, metersLong: -500)
        
        let rangePointNE:CLLocationCoordinate2D = MapboxManager.metersToDegrees(coord: map.centerCoordinate, metersLat: 500, metersLong: 500)
        
        let bounds = MGLCoordinateBoundsMake(rangePointSW, rangePointNE)
        map.setVisibleCoordinateBounds(bounds, edgePadding: UIEdgeInsets.zero, animated: false)
        
        let rangeCircle = MapboxManager.polygonCircleForCoordinate(coordinate: map.centerCoordinate,
                                                                   meterRadius: 500.0)
        map.add(rangeCircle)
        
        let rangeMarker = CustomPointAnnotation()
        rangeMarker.coordinate = map.centerCoordinate
        rangeMarker.markerType = K.Mapbox.Marker.Type.Range
        map.addAnnotation(rangeMarker)
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
    
        locationManager.stopUpdatingLocation()
        currentLocation = locations[0].coordinate
        
        DispatchQueue.once {
            updateMapLocation()
            initMapRange()
        }
        
    }
    
    func updateMapLocation() {
        map.setCenter(currentLocation, zoomLevel: 14, animated:false)
        
        //reverse geocode label
        AFNetworkingManager.getReverseGeocodingFor(coordinate: currentLocation) { (data, error) in
            if error == nil {
                self.locationHeaderLabel.text = K.String.Mapbox.CurrentLocationHeader.localized
                self.locationLabel.text = DataParseManager.parseReverseGeoData(data: data)
            }
            
            else {
                print("REVERSE GEOCODE ERROR: \(error?.localizedDescription)")
            }
        }
    }
    
    // MARK: - MGLMapViewDelegate
//    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
//        mapView.setCenter(userLocation!.coordinate, zoomLevel: 14, animated:false)
//        
//        //set up the rest now that we have our location
//        initMapRange()
//    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 0.2
    }
    
    private func mapView(mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return UIColor.clear
    }
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return K.Color.localityMapAccent
    }
    
    private func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        let thisMarker = annotation as! CustomPointAnnotation
        
        switch thisMarker.markerType {
            
        case K.Mapbox.Marker.Type.Range:
            let img = UIImage(named: K.Mapbox.Marker.Image.Range)
            let mglImg = MGLAnnotationImage(image: img!, reuseIdentifier: K.Mapbox.Marker.Type.Range)
            mglImg.accessibilityFrame = CGRect(x:0, y:0, width:(img?.size.width)!, height:(img?.size.height)!)
            return mglImg
            
        default:
            return MGLAnnotationImage(image: UIImage(), reuseIdentifier: "")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
