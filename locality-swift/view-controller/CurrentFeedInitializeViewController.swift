//
//  CurrentFeedInitializeViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/4/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Mapbox

class CurrentFeedInitializeViewController: LocalityBaseViewController, MGLMapViewDelegate, CLLocationManagerDelegate, LocationSliderDelegate {

    @IBOutlet weak var map : MGLMapView!
    @IBOutlet weak var locationHeaderLabel : UILabel!
    @IBOutlet weak var locationLabel : UILabel!
    @IBOutlet weak var setRangeButton : UIButton!
    
    @IBOutlet weak var slider : LocationSlider!
    
    //var slider:LocationSlider!
    
    var locationManager:CLLocationManager!
    var currentLocation:CLLocationCoordinate2D!
    
    var currentRangeIndex:Int!
    var sliderSteps:[RangeStep]!
    
    var hasMapped:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initButtons()
        initRangeSlider()
        initMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initButtons() {
        setRangeButton.addTarget(self, action: #selector(setRangeDidTouch), for: .touchUpInside)
    }
    
    func initRangeSlider() {
        
        sliderSteps = slider.initSlider()
        slider.delegate = self
        
        //set currentIndex to default of slider
        currentRangeIndex = slider.currentStep
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
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //init light style
        let localityStyleURL = K.Mapbox.MapStyle
        map.styleURL = URL(string:localityStyleURL)
        
        map.delegate = self
    }
    
    func updateMapRange() {
        
        //remove all annotations first
        if let annotations = map.annotations {
            for ann in annotations {
                    map.removeAnnotation(ann)
            }
        }
        
        map.centerCoordinate = currentLocation
        let currentRadius:Double = Util.radiusInMeters(range: Float(sliderSteps[currentRangeIndex].distance))
        
        let rangePointSW:CLLocationCoordinate2D = MapboxManager.metersToDegrees(coord: map.centerCoordinate, metersLat: -currentRadius, metersLong: -currentRadius)
        
        let rangePointNE:CLLocationCoordinate2D = MapboxManager.metersToDegrees(coord: map.centerCoordinate, metersLat: currentRadius, metersLong: currentRadius)
        
        let bounds = MGLCoordinateBoundsMake(rangePointSW, rangePointNE)
        map.setVisibleCoordinateBounds(bounds, edgePadding: UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20), animated: false)
        
        let rangeCircle = MapboxManager.polygonCircleForCoordinate(coordinate: map.centerCoordinate,
                                                                   meterRadius: currentRadius)
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
        
//        DispatchQueue.once {
//            updateMapLocation()
//            updateMapRange()
//        }
        
        if hasMapped == false {
            map.setCenter(currentLocation, animated:false)
            updateMapRange()
            hasMapped = true
        }
        
    }
    
    func updateMapLocation() {
        map.setCenter(currentLocation, zoomLevel: 14, animated:false)
        
        //reverse geocode label
        GoogleMapsManager.reverseGeocode(coord: currentLocation) { (address, error) in
            self.locationHeaderLabel.text = K.String.Mapbox.CurrentLocationHeader.localized
            self.locationLabel.text = Util.locationLabel(address: address!)
        }
    }
    
    func onboardCurrentLocation() {
        let current = FeedLocation(coord: currentLocation,
                                   name: K.String.CurrentFeedName,
                                   range: Float(sliderSteps[currentRangeIndex].distance),
                                   current: true)
        
        current.location = self.locationLabel.text!
        CurrentUser.shared.currentLocationFeed = current
        
        //write to Firebase
        
        FirebaseManager.getCurrentUserRef().child(K.DB.Var.CurrentLocation).setValue(current.toFireBaseObject()) { (error, ref) in
            
            if error == nil {
                //now that we have successfully saved the current location we can set isFirstVisit false.
                FirebaseManager.getCurrentUserRef().child(K.DB.Var.IsFirstVisit).setValue(false)
                
                self.moveIntoApp()
            }
        }
    }
    
    func moveIntoApp() {
        let feedMenuVC:FeedMenuTableViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.FeedMenu) as! FeedMenuTableViewController
        
        SlideNavigationController.sharedInstance().popAllAndSwitch(to: feedMenuVC, withCompletion: nil)
        
        let newVC:FeedViewController = Util.controllerFromStoryboard(id: K.Storyboard.ID.Feed) as! FeedViewController
        
        newVC.thisFeed = CurrentUser.shared.currentLocationFeed
        SlideNavigationController.sharedInstance().pushViewController(newVC, animated: false)
    }
    
    //CTA
    func setRangeDidTouch(sender:UIButton) {
        //save current location
        onboardCurrentLocation()
    }
    
    // MARK: - MGLMapViewDelegate
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
    
    //MARK: - LocationSliderDelegate
    func sliderValueChanged(step: Int) {
        currentRangeIndex = step
        updateMapRange()
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
